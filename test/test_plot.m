G_Graph = digraph(Adj);
G_Control = digraph(Control);
G_Data = digraph(Data);
G_Rely = digraph(Rely);
figure(4)
plot(G_Graph)
print(gcf,'-dpng','G_Graph.png') 
