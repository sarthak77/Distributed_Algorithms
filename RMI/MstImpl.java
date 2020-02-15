import java.util.*; 

// Extends and Implement the class 
// and interface respectively 
public class MstImpl extends java.rmi.server.UnicastRemoteObject implements Mst
{ 
    //pair class for storing in adjacency list
    class pair
    {
        int x,y;
    }

    //class for creating graph
    @SuppressWarnings("unchecked")
    static class Graph 
    { 
    	int V; 
    	LinkedList<pair> adjListArray[]; 
    
    	Graph(int V) 
    	{ 
    		this.V=V; 

    		adjListArray=new LinkedList[V]; 

            for(int i=0;i<V;i++)
            { 
    			adjListArray[i]=new LinkedList<>(); 
    		} 
    	} 
    } 

    //edge class for priority queue
    class edge
    {
        int v1,v2,w;
    }

    //custom comparator for priority queue
    class comparator implements Comparator<edge>
    {
        @Override
        public int compare(edge e1,edge e2)
        {
            return e1.w-e2.w;
        }
    }

    //function to add edge in the graph
	void addEdge(Graph graph, int src, int dest, int w) 
	{ 
        pair p1=new pair();
        p1.x=dest;
        p1.y=w;
        pair p2=new pair();
        p2.x=src;
        p2.y=w;

		graph.adjListArray[src].add(p1); 
		graph.adjListArray[dest].add(p2); 
	} 
    
    //function to get mst of the graph
    long getmst(Graph graph)
    {
        //n=no of vertices
        int n=graph.V;

        //initialising check array to false (default is null)
        Boolean check[]=new Boolean[n];
        for(int i=0;i<n;i++)
        {
            check[i]=false;
        }

        //declaring variables
        PriorityQueue<edge> pq =new PriorityQueue<edge>(new comparator());
        int count=0,v1,v2,w;
        long ret=0;

        //insert min weight edge of 0th vertex in pq
        pair tp1=new pair();
        Boolean fl=false;
        tp1.y=Integer.MAX_VALUE;

        for(pair p: graph.adjListArray[0])
        {
            if(p.y<=tp1.y)
            {
                fl=true;
                tp1.x=p.x;
                tp1.y=p.y;
            }
        }

        edge e1=new edge();
        //if 0th node not connected to any node then no mst
        if(fl)
        {
            e1.v1=0;
            e1.v2=tp1.x;
            e1.w=tp1.y;
            pq.add(e1);
        }
        else
            ret=-1;
        
        //running prims algorithm
        while(pq.peek()!=null)
        {
            //pop min edeg from pq
            e1=pq.poll();//get top element and pop
            v1=e1.v1;
            v2=e1.v2;
            w=e1.w;

            //if no cycle formed
            if(!check[v1] || !check[v2])
            {
                check[v1]=true;
                check[v2]=true;
                
                count++;//increment adge count
                ret+=w;//add to mst

                //add edges of v1 to pq
                for(pair p:graph.adjListArray[v1])
                {
                    if(!check[p.x])
                    {
                        edge e =new edge();
                        e.v1=v1;
                        e.v2=p.x;
                        e.w=p.y;
                        pq.add(e);
                    }
                }

                //add edges of v2 to pq
                for(pair p:graph.adjListArray[v2])
                {
                    if(!check[p.x])
                    {
                        edge e =new edge();
                        e.v1=v2;
                        e.v2=p.x;
                        e.w=p.y;
                        pq.add(e);
                    }
                }
            }
        }

        //check if no mst
        if(count!=(n-1))
            ret=-1;
        
		return ret;
    }

	// Constructor Declaration 
	public MstImpl() throws java.rmi.RemoteException 
	{ 
		super(); 
	} 

	// Implementing the methods 

	List<String> gr_name = new ArrayList<String>();
	List<Graph>  gr = new ArrayList<Graph>();

	public void add_graph(String s,int n) throws java.rmi.RemoteException
	{
		gr_name.add(s);
		Graph graph=new Graph(n);
		gr.add(graph);
	}

	public void add_edge(String s,int v1,int v2,int w) throws java.rmi.RemoteException
	{
		int ind=gr_name.indexOf(s);
        Graph g = gr.get(ind);
        //dont add self loops
        if(v1!=v2)
        {
            //because input given acc to 1 based indexing
            addEdge(g,v1-1,v2-1,w);
        }
	}

	public long get_mst(String s) throws java.rmi.RemoteException
	{
		int ind=gr_name.indexOf(s);
		Graph g = gr.get(ind);
		return getmst(g);
	}
} 