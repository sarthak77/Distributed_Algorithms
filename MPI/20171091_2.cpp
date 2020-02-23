#include<bits/stdc++.h>
#include "mpi.h"
using namespace std;

//declare vectors
vector<long long int>inp;
vector<long long int>a;
vector<long long int>b;
vector<long long int>c;
vector<long long int>dist;

int main(int argc,char **argv)
{
    int rank,p;
    long long int vertices,edges,source;
    
    MPI_Init(&argc,&argv);
    MPI_Comm_rank(MPI_COMM_WORLD,&rank);
    MPI_Comm_size(MPI_COMM_WORLD,&p);

    if(rank==0)
    {
        //scan input
        string f=argv[1];
        ifstream x(f);
        long long int t;
        while(x >> t)
            inp.push_back(t);

        //find v,e,and s
        vertices=inp[0];
        edges=inp[1];
        source=inp[3*edges+2];

        //construct a,b,c arrays
        for(long long int i=0;i<edges;i++)
        {
            a.push_back(inp[2+3*i]);
            b.push_back(inp[3+3*i]);
            c.push_back(inp[4+3*i]);
        }

        //padd the array to make it divisible by p
        while(edges%p)
        {
            a.push_back(0);
            b.push_back(0);
            c.push_back(0);
            edges++;
        }

        x.close();
    }

    MPI_Barrier(MPI_COMM_WORLD);
    double tbeg=MPI_Wtime();

    /* write your code here */

    //broadcast graph
    MPI_Bcast(&vertices,1,MPI_LONG_LONG_INT,0,MPI_COMM_WORLD);
    MPI_Bcast(&source,1,MPI_LONG_LONG_INT,0,MPI_COMM_WORLD);
    MPI_Bcast(&edges,1,MPI_LONG_LONG_INT,0,MPI_COMM_WORLD);

    //construct dist array
    for(long long int i=0;i<=vertices;i++)
        dist.push_back(LONG_MAX);
    dist[source]=0;

    //declare chunks
    long long int rchunksz;
    long long int chunksz=edges/p;
    long long int computesz=edges/p;
    long long int* chunk1=(long long int*)malloc(chunksz*sizeof(long long int));
    long long int* chunk2=(long long int*)malloc(chunksz*sizeof(long long int));
    long long int* chunk3=(long long int*)malloc(chunksz*sizeof(long long int));


    MPI_Scatter(a.data(),chunksz,MPI_LONG_LONG_INT,chunk1,chunksz,MPI_LONG_LONG_INT,0,MPI_COMM_WORLD);
    MPI_Scatter(b.data(),chunksz,MPI_LONG_LONG_INT,chunk2,chunksz,MPI_LONG_LONG_INT,0,MPI_COMM_WORLD);
    MPI_Scatter(c.data(),chunksz,MPI_LONG_LONG_INT,chunk3,chunksz,MPI_LONG_LONG_INT,0,MPI_COMM_WORLD);


    //apply Bellman Ford
    for(long long int i=1;i<vertices;i++)
    {
        for(long long int j=0;j<chunksz;j++)
        {
            if(dist[chunk2[j]]!=LONG_MAX)
            {
                if(dist[chunk1[j]]>dist[chunk2[j]]+chunk3[j])
                    dist[chunk1[j]]=dist[chunk2[j]]+chunk3[j];
            }

            if(dist[chunk1[j]]!=LONG_MAX)
            {
                if(dist[chunk2[j]]>dist[chunk1[j]]+chunk3[j])
                    dist[chunk2[j]]=dist[chunk1[j]]+chunk3[j];
            }
        }

        //merge across processes        
        MPI_Allreduce(MPI_IN_PLACE,dist.data(),vertices+1,MPI_LONG_LONG_INT,MPI_MIN,MPI_COMM_WORLD);
    }

    MPI_Barrier(MPI_COMM_WORLD);

    //output to file
    if(rank==0)
    {
        ofstream x;
        string f=argv[2];
        x.open(f);
        for(long long int i=1;i<=vertices;i++)
        {
            if(dist[i]!=LONG_MAX)
                x << i << " " << dist[i] << "\n";
            else 
                x << i << " -1\n";
        }
        x.close();
    }

    double elapsedTime=MPI_Wtime()-tbeg;
    double maxTime;
    MPI_Reduce(&elapsedTime,&maxTime,1,MPI_DOUBLE,MPI_MAX,0,MPI_COMM_WORLD);
    if (rank==0)
        cout << maxTime << "\n";

    MPI_Finalize();
    return 0;
}