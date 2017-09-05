#script (python)
import clingo
import networkx as nx
import matplotlib.pyplot as plt
import matplotlib.patches as ptch
import random

last_services = None
last_routes = None
last_vehicles = None

def on_model(model):
	print model
	
	#Store details of the last model. Simply storing the model for later usage does not work, as it is disposed
	global last_services
	global last_routes
	global last_vehicles
	
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
 
def on_finish(res):
	print res
	
	global last_services
	global last_routes
	global last_vehicles
	
	if last_routes is not None:
		G=nx.DiGraph()
		vehicles = dict()
		
		#Generate random colors for the vehicles
		for s in last_vehicles:
			vehicles[s] = random.uniform(0, 1),random.uniform(0, 1),random.uniform(0, 1)
		
		#Color nodes depending on who is servicing them
		node_colors = dict()
		node_colors["0"] = 0,0,0 #Depot is always black
		
		for s in last_services:
			G.add_node(s[0])
			node_colors[s[0]] = vehicles[s[1]]
		
		#Add edges based on routes. If two vehicles share an edge, mix the colors
		edge_colors = dict()
		edge_labels = dict()
		
		for s in last_routes:
			c_key = s[0],s[1]
			#Case edge is shared
			if (c_key in edge_colors):
				edge_labels[c_key] = edge_labels[c_key] + "," + s[2]
				c_color = edge_colors[c_key]
				new_color = vehicles[s[2]]
				c_color = (c_color[0] + new_color[0]) / 2, (c_color[1] + new_color[1]) / 2, (c_color[2] + new_color[2]) / 2
				edge_colors[c_key] = c_color
			#First vehicle to use the edge
			else:
				G.add_edge(s[0],s[1])
				edge_colors[c_key] = vehicles[s[2]]
				edge_labels[c_key] = s[2]

		#Transform structures, so they can be used to draw
		final_edge_colors = []
		for (u,v) in G.edges():
			final_edge_colors.append(edge_colors[u,v])
			
		final_node_colors=[]
		for u in G.nodes():
			final_node_colors.append(node_colors[u])

		#Draw the graph
		pos=nx.spring_layout(G)
		nx.draw_networkx(G,pos,arrows=True, node_color=final_node_colors, edge_color=final_edge_colors)
		nx.draw_networkx_edge_labels(G,pos, edge_labels=edge_labels)
		
		#Draw a legend, for each vehicle a color
		vehicle_names = []
		vehicle_patches = []
		for k,v in vehicles.iteritems():
			vehicle_names.append(k)
			vehicle_patches.append(ptch.Patch(color=v))
			
		plt.figlegend(vehicle_patches, vehicle_names,'lower left')
		plt.show()
 
def main(prg):
	prg.ground([("base", [])])
	prg.solve(on_model=on_model, on_finish=on_finish)

#end.