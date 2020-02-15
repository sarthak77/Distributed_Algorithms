import java.rmi.Naming; 

public class Server
{ 
	public Server(int port) 
	{ 
		try
		{ 
			//Create a object reference for the interface 
			Mst c=new MstImpl(); 

			java.rmi.registry.LocateRegistry.createRegistry(port);
			
			//Bind the localhost with the service 
			Naming.rebind("rmi://localhost:"+port+"/MstService",c); 
		} 
		catch(Exception e)
		{ 
			System.out.println("ERR: "+e); 
		} 
	} 

	public static void main(String[] args) 
	{ 
		if(args.length!=1)
		{
			System.out.println("Usage:java Server <server_port>");
			System.exit(0);
		}
		else
		{
			int port=Integer.parseInt(args[0]);
			new Server(port); 
		}
	} 
} 
