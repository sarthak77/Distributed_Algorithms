//Creating an Interface 
public interface Mst extends java.rmi.Remote
{ 
	//Declaring the methods 
	public void add_graph(String s,int n)
			throws java.rmi.RemoteException; 

	public void add_edge(String s,int v1,int v2,int w)
			throws java.rmi.RemoteException; 

	public int get_mst(String s)
			throws java.rmi.RemoteException; 
} 