function G_plot(Graph, Control, Data, Rely)
%%
G_Graph = digraph(Graph);
G_Control = digraph(Control);
G_Data = digraph(Data);
G_Rely = digraph(Rely);
figure(1)
plot(G_Graph)
print(gcf,'-dpng','G_Graph.png', '-r600') ;
figure(2)
plot(G_Control)
print(gcf,'-dpng','G_Control.png', '-r600') ;
figure(3)
plot(G_Data)
print(gcf,'-dpng','G_Data.png', '-r600') ;
figure(4)
plot(G_Rely)
print(gcf,'-dpng','G_Rely.png', '-r600') ;
%%
figure(5)
spy(Graph)
print(gcf,'-dpng','Spy_Graph.png', '-r600') ;
figure(6)
spy(Control)
print(gcf,'-dpng','Spy_Control.png', '-r600') ;
figure(7)
spy(Data)
print(gcf,'-dpng','Spy_Data.png', '-r600') ;
figure(8)
spy(Rely)
print(gcf,'-dpng','Spy_Rely.png', '-r600') ;
end
