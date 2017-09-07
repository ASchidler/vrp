#script (python)
import clingo
import networkx as nx
import matplotlib.pyplot as plt
import matplotlib.patches as ptch
import random

last_services = None
last_routes = None
last_vehicles = None
last_order = None
last_edges = None

#Is called whenever a model is found
def on_model(model):
	print model
	
	#Store details of the last model. Simply storing the model for later usage does not work, as it is disposed
	global last_services
	global last_routes
	global last_vehicles
	global last_order
	global last_edges
	
	last_vehicles = []
	for s in model.symbols(atoms=True):
		if s.name == 'vehicle':
			last_vehicles.append(str(s.arguments[0]))
			
	last_services = []
	for s in model.symbols(atoms=True):
		if s.name == 'services':
			last_services.append((str(s.arguments[0]), str(s.arguments[1])))
	
	last_routes = []
	for s in model.symbols(atoms=True):
		if s.name == 'route':
			last_routes.append((str(s.arguments[0]), str(s.arguments[1]), str(s.arguments[2])))
			
	last_order = []
	for s in model.symbols(atoms=True):
		if s.name == 'routeOrder':
			last_order.append((str(s.arguments[0]), str(s.arguments[1]), int(str(s.arguments[2])), str(s.arguments[3])))
 
	last_edges = []
	for s in model.symbols(atoms=True):
		if s.name == 'edge':
			last_edges.append((str(s.arguments[0]), str(s.arguments[1])))
			
def on_finish(res):
	print res

	global last_routes
	global last_vehicles
	
	#Check if there is a model
	if last_routes is not None:
		output_routes()
		#create and draw graph
		G = generate_graph()
		pos=nx.circular_layout(G)
		vehicles = dict()
		
		#Generate random colors for the vehicles
		for s in last_vehicles:
			vehicles[s] = random.uniform(0, 1),random.uniform(0, 1),random.uniform(0, 1)
		
		#draw
		draw_nodes(vehicles,G,pos)
		draw_edges(vehicles,G,pos)
		draw_legend(vehicles)
	
		plt.show()

def generate_graph():
	G=nx.DiGraph()
	global last_edges
	for s in last_edges:
		G.add_node(s[0])
		G.add_node(s[1])
		G.add_edge(s[0],s[1])
	
	return G
		
def draw_nodes(vehicles, G, pos):
	global last_services
	
	#Color nodes depending on who is servicing them
	node_colors = dict()
	node_colors["0"] = 0,0,0 #Depot is always black
		
	for s in last_services:
		node_colors[s[0]] = vehicles[s[1]]
		
	final_node_colors=[]
	for u in G.nodes():
		final_node_colors.append(node_colors[u])
			
	nx.draw_networkx_nodes(G,pos,node_color=final_node_colors)
	nx.draw_networkx_labels(G,pos)
	
def draw_edges(vehicles, G, pos):
	global last_routes
	
	#Add edges based on routes. If two vehicles share an edge, mix the colors
	edge_colors = dict()
	edge_labels = dict()
	
	for s in last_routes:
		c_key = s[0],s[1]
		#Case edge is shared
		if (c_key in edge_colors):
			edge_labels[c_key].append(s[2])
			c_color = edge_colors[c_key]
			new_color = vehicles[s[2]]
			c_color = (c_color[0] + new_color[0]) / 2, (c_color[1] + new_color[1]) / 2, (c_color[2] + new_color[2]) / 2
			edge_colors[c_key] = c_color
		#First vehicle to use the edge
		else:
			edge_colors[c_key] = vehicles[s[2]]
			edge_labels[c_key] = [s[2]]

	#Transform structures, so they can be used to draw
	final_edge_labels = dict()
	
	final_edge_colors = []
	for (u,v) in G.edges():
		#Is the edge used by a vehicle?
		if (u,v) in edge_colors:
			final_edge_colors.append(edge_colors[u,v])
			
			#Label both directions the same, otherwise one might block the other and the labelling is wrong
			if (v,u) in edge_labels:
				temp_list = edge_labels[u,v] + edge_labels[v,u]
			else:
				temp_list = edge_labels[u,v]
				
			#Eliminate duplicate entries and make a single string
			seen = set()
			temp_list2 = [x for x in temp_list if not (x in seen or seen.add(x))]

			if len(temp_list2) > 1:
				final_edge_labels[u,v] = ",".join(temp_list2)
			else:
				final_edge_labels[u,v] = temp_list2[0] #join seems to product no string if only one element exists
		# Not used edges are grey
		else:
			final_edge_colors.append((0.95,0.95,0.95))
	
	nx.draw_networkx_edges(G,pos, edge_color=final_edge_colors)
	nx.draw_networkx_edge_labels(G,pos, edge_labels=final_edge_labels)

def draw_legend(vehicles):
	vehicle_names = []
	vehicle_patches = []
	for k,v in vehicles.iteritems():
		vehicle_names.append(k)
		vehicle_patches.append(ptch.Patch(color=v))
		
	plt.figlegend(vehicle_patches, vehicle_names,'lower left')

def output_routes():
	global last_order
	global last_vehicles
	
	vehicle_routes = dict()
	
	for veh in last_vehicles:
		vehicle_routes[veh] = []
			
	for r in last_order:
		if r[0] != r[1]:
			vehicle_routes[r[3]].append((r[1],r[2]))
		
	for k,v in vehicle_routes.iteritems():
		sorted(v, key=lambda x: x[1])
		output = k +": 0"
		
		for n in v:
			output += " - "+n[0]
		
		print output
			
def main(prg):
	prg.ground([("base", [])])
	prg.solve(on_model=on_model, on_finish=on_finish)

#end.
