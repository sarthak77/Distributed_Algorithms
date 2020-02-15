import java.net.MalformedURLException; 
import java.rmi.Naming; 
import java.rmi.NotBoundException; 
import java.rmi.RemoteException; 
import java.util.*; 
import java.nio.charset.StandardCharsets; 
import java.nio.file.*; 
import java.io.*; 

public class Client
{ 
	@SuppressWarnings("unchecked")
	public static void main(String[] args) 
	{ 
		try
		{ 
			if(args.length!=2)
			{
				System.out.println("Usage:java Client <server_ip> <server_port>");
				System.exit(0);
			}

			String sip=args[0];//server ip
			int sport=Integer.parseInt(args[1]);//server port

			// Create an remote object with the same name 
			// Cast the lookup result to the interface
			Mst c = (Mst) Naming.lookup("rmi://"+sip+":"+sport+"/MstService"); 

			//keyword strings
			String s1="add_graph";
			String s2="add_edge";
			String s3="get_mst";

			//take input
			Scanner inp=new Scanner(System.in);
			while(inp.hasNext())
			{
				String s =inp.nextLine();

				//if ctrl+D
				if(s==null)
					break;
				
				//if enter pressed
				if(s.length()==0)
					continue;

				//split input string
				String[] strarr=s.split(" ",5);
				
				if(s1.equals(strarr[0]))
					c.add_graph(strarr[1],Integer.parseInt(strarr[2]));
				else if(s2.equals(strarr[0]))
					c.add_edge(strarr[1],Integer.parseInt(strarr[2]),Integer.parseInt(strarr[3]),Integer.parseInt(strarr[4]));
				else
					System.out.println(c.get_mst(strarr[1]));
			}
		} 

		catch (MalformedURLException murle)
		{ 
			System.out.println("\nMalformedURLException: "+murle); 
		} 
		catch (RemoteException re)
		{ 
			System.out.println("\nRemoteException: "+re); 
		} 
		catch (NotBoundException nbe)
		{ 
			System.out.println("\nNotBoundException: "+nbe); 
		} 
		catch (java.lang.ArithmeticException ae)
		{ 
			System.out.println("\nArithmeticException: "+ae); 
		} 
	} 
} 