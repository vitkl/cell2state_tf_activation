import numpy as np

#create function to convert adata X (sparse marix) to convert to 2d array
def sparse_to_2d_arr(adata):
    #write docstrint for function with input and output
    """
    Parameters
    ----------
    adata : AnnData
        AnnData object with adata.X (sparse matrix) to convert to 2d array
    Returns
    -------
    dense_count_2d_arr : np.array
    This function converts adata.X (sparse matrix) to a 2d array
    """

    #convert sparse matrix to dense matrix
    dense_count_mtx=adata.X.todense()
    print(dense_count_mtx)
    #convert matrix into 2d array
    dense_count_2d_arr=np.array(dense_count_mtx)
    #convert 2d array to dtype int
    dense_count_2d_arr=dense_count_2d_arr.astype(int)

    return dense_count_2d_arr

#Create a function to count the number of times each value occurs in each row
def count_guide_frequency(dense_count_2d_arr):
    """
    Parameters
    ----------
    dense_count_2d_arr : np.array
        2d array of sgRNA counts per cell
    Returns
    -------
    count_frequncy_arr : np.array
        2d array of sgRNA counts per cell with the number of times each value occurs in each row
    """

        
    m = dense_count_2d_arr.shape[0]    
    n = dense_count_2d_arr.max()+1
    count_frequncy_arr = np.zeros((dense_count_2d_arr.max()+1,dense_count_2d_arr.shape[1]))

    for x in range(dense_count_2d_arr.shape[1]):
        #count the number of times each counts of sgRNA occurs in each row
        bin_count_arr = np.bincount(dense_count_2d_arr[:,x])
        

        #create zero array to add to bin_count_arr to make the length of the array equal to the max value in dense_count_2d_arr
        n_filler = n-len(bin_count_arr)
        zero_filler = np.zeros(n_filler)
        full_bin_count_arr = np.concatenate((bin_count_arr,zero_filler))
        count_frequncy_arr[:,x] = full_bin_count_arr 
        

    return count_frequncy_arr #exclude first column as it only consists of zeros