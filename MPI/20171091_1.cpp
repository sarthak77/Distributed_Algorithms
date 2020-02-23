/*
Assumptions: data is in the range of long long int
*/

#include<bits/stdc++.h>
#include "mpi.h"
using namespace std;

vector<long long int>inp;

//merge function to merge two sorted arrays
void merge_chunk(long long int* aux,long long int arr1[],long long int arr2[],long long int s1,long long int s2)
{
	long long int i,j,k;
    i=j=k=0;
	
    while(i<s1 && j<s2)
    {
        if(arr1[i]<arr2[j])
        {
            aux[k]=arr1[i];
            k++;
            i++;
        }
        else
        {
            aux[k]=arr2[j];
            k++;
            j++;
        }
    }

	while(i<s1)
    {
		aux[k]=arr1[i];
        k++;
        i++;
    }
	while(j<s2)
    {
		aux[k]=arr2[j];
        k++;
        j++;
    }
}

//normal qsort
void normal_qsort(long long int* arr,long long int beg,long long int end)
{
    if(beg>=end)
        return;

    long long int i,j,pivot;
    pivot=(beg+end)/2;
    swap(arr[beg],arr[pivot]);

    i=beg+1;
    j=end;

    //partition around pivot
    while(j>=i)
    {
        if(arr[i]<=arr[beg])
            i++;
        else if(arr[j]>arr[beg])
            j--;
        else
            swap(arr[i],arr[j]);
    }

    swap(arr[j],arr[beg]);

    //recursively call left and right subarray
    normal_qsort(arr,beg,j-1);
    normal_qsort(arr,j+1,end);
    return;
}

int main(int argc,char **argv)
{
    int rank,p;
    long long int n,tn,t;
    
    MPI_Init(&argc,&argv);

    MPI_Comm_rank(MPI_COMM_WORLD,&rank);
    MPI_Comm_size(MPI_COMM_WORLD,&p);

    //scan input from root
    if(rank==0)
    {
        string f=argv[1];
        ifstream x(f);
        while(x >> t)
            inp.push_back(t);

        //padding to make size of every process constant
        n=inp.size();
        tn=n;
        while(n%p)
        {
            inp.push_back(LONG_MAX);
            n++;
        }
        x.close();
    }

    MPI_Barrier(MPI_COMM_WORLD);
    double tbeg=MPI_Wtime();

    /* write your code here */

    MPI_Bcast(&n,1,MPI_LONG_LONG_INT,0,MPI_COMM_WORLD);

    //declaring chunk variables
    long long int rchunksz;
    long long int chunksz=n/p;
    long long int computesz=n/p;
    long long int* chunk=(long long int*)malloc(chunksz*sizeof(long long int));

    MPI_Scatter(inp.data(),chunksz,MPI_LONG_LONG_INT,chunk,chunksz,MPI_LONG_LONG_INT,0,MPI_COMM_WORLD);

    //apply quick sort to every chunk
    normal_qsort(chunk,0,chunksz-1);

    //run p-1 iterations to merge all chunks
    for(long long int i=1;i<p;i=(i<<1))
    {
        //if not leftmost node, send to leftmost node and break
        if(rank%(i<<1))
        {
	    	MPI_Send(chunk,computesz,MPI_LONG_LONG_INT,rank-i,0,MPI_COMM_WORLD);	
            break;
        }

        //if leftmost node then receive from (rank+i)th process 
        else if(rank+i<p)
        {
            //set receive chunk size
            rchunksz=chunksz*i;
            if(chunksz*(rank+2*i)>n)
                rchunksz=n-chunksz*(rank+i);

            long long int* tchunk=(long long int*)malloc(chunksz*sizeof(long long int));
            long long int* mchunk=(long long int*)malloc((computesz+rchunksz)*sizeof(long long int));

            //receive chunk from right nodes
            MPI_Recv(tchunk,rchunksz,MPI_LONG_LONG_INT,rank+i,0,MPI_COMM_WORLD,NULL);

            //merge the chunks
            merge_chunk(mchunk,chunk,tchunk,computesz,rchunksz);

            //make chunk=chunk+received
            free(chunk);
            chunk=mchunk;
            computesz+=rchunksz;
        }
    }

    MPI_Barrier(MPI_COMM_WORLD);

    if(rank==0)
    {
        ofstream x;
        string f=argv[2];
        x.open(f);
        for(long long int i=0;i<tn;i++)
            x << chunk[i] << " "; 
        x << "\n";
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