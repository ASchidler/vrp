#script (python)
import clingo
import networkx as nx
import matplotlib.pyplot as plt
import matplotlib.patches as ptch
import random

last_model = None

def on_model(model):
	print model
	last_model = model
	if last_model is not None:
		G=nx.DiGraph()
		vehicles = dict()
		
		for s in last_model.symbols(atoms=True):
			if s.name == 'vehicle':
				vehicles[str(s.arguments[0])] = random.uniform(0, 1),random.uniform(0, 1),random.uniform(0, 1)
		
		node_colors = dict()
		node_colors["0"] = 0,0,0
		
		for s in last_model.symbols(atoms=True):
			if s.name == 'services':
				G.add_node(str(s.arguments[0]))
				node_colors[str(s.arguments[0])] = vehicles[str(s.arguments[1])]
		
		edge_colors = dict()
		edge_labels = dict()
		
		for s in last_model.symbols(atoms=True):
			if s.name == 'route':
				c_key = str(s.arguments[0]), str(s.arguments[1])
				if (c_key in edge_colors):
					edge_labels[c_key] = edge_labels[c_key] + "," + str(s.arguments[2])
					c_color = edge_colors[c_key]
					new_color = vehicles[str(s.arguments[2])]
					c_color = (c_color[0] + new_color[0]) / 2, (c_color[1] + new_color[1]) / 2, (c_color[2] + new_color[2]) / 2
					edge_colors[c_key] = c_color
				else:
					G.add_edge(str(s.arguments[0]), str(s.arguments[1]))
					edge_colors[c_key] = vehicles[str(s.arguments[2])]
					edge_labels[c_key] = str(s.arguments[2])
					
		final_edge_colors = []
		for (u,v) in G.edges():
			final_edge_colors.append(edge_colors[u,v])
			
		final_node_colors=[]
		for u in G.nodes():
			final_node_colors.append(node_colors[u])
		
		pos=nx.spring_layout(G)
		nx.draw_networkx(G,pos,arrows=True, node_color=final_node_colors, edge_color=final_edge_colors)
		nx.draw_networkx_edge_labels(G,pos, edge_labels=edge_labels)
		
		vehicle_names = []
		vehicle_patches = []
		for k,v in vehicles.iteritems():
			vehicle_names.append(k)
			vehicle_patches.append(ptch.Patch(color=v))
			
		plt.figlegend(vehicle_patches, vehicle_names,'lower left')
		plt.show()
	
 
def on_finish(res):
	print res
 
def main(prg):
	prg.ground([("base", [])])
	prg.solve(on_model=on_model, on_finish=on_finish)

#end.