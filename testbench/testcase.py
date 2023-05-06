from arithmetic import * 
import numpy as np

def read_file(file_name):
    with open( file_name, "r+" ) as f:
        data_list = f.readlines()
    data_list = [ i.replace('\n','') for i in data_list ]
    return data_list

def main():
    # -----------------------------------------------------------------
    # read data
    # -----------------------------------------------------------------
    data_input = read_file( "../testcase/Input.txt" )
    data_weight = read_file( "../testcase/Weight.txt" )
    data_output = read_file( "../testcase/Output.txt" )

    # -----------------------------------------------------------------
    # parse
    # -----------------------------------------------------------------
    mat_input = np.zeros( (16,16), dtype=np.int64 )
    for i in range(16):
        for j in range(16):
            tmp = data_input[ i*16 + j ]
            mat_input[j][i] = convert_str_to_int( tmp )
            
    mat_weight = np.zeros( (8,16,16), dtype=np.int64 )
    for n in range(8):
        for i in range(16):
            for j in range(16):
                tmp = data_weight[n*16*16 + i*16 + j]
                mat_weight[n][j][i] = convert_str_to_int( tmp )
                
    mat_ref_real = np.zeros( (16,16), dtype=np.float32 )
    mat_ref_int = np.zeros( (16,16), dtype=np.int32 )
    for i in range(16):
        for j in range(16):
            tmp = convert_str_to_int(data_output[i*16+j])
            mat_ref_int[j][i] = tmp
            mat_ref_real[j][i] = convert_int_to_ft(tmp)
    
    # -----------------------------------------------------------------
    # compute
    # -----------------------------------------------------------------
    mat_result = np.zeros( (8,16,16), dtype=np.int64 )
    mat_result_unround = np.zeros( (8,16,16), dtype=np.int64 )

    for i in range(16):
        for j in range(16):
            tmp = 0
            for k in range(16):
                # tmp += mat_input[i][k] * mat_weight[0][k][j]
                tmp_mul = customft_mac_mul( mat_input[i, k] , mat_weight[0,k,j] )
                tmp = customft_mac_add( tmp, tmp_mul )
            tmp = customft_mac_round( tmp )
            mat_result[0][i][j] = tmp 

    for n in range(1,8,1):
        for i in range(16):
            for j in range(16):
                tmp = 0
                for k in range(16):
                    # tmp += mat_result[n-1][i][k] * mat_weight[n][k][j]
                    tmp_mul = customft_mac_mul( mat_result[n-1][i, k], mat_weight[n, k, j] )
                    tmp = customft_mac_add( tmp, tmp_mul )
                mat_result_unround[n][i][j] = tmp
                tmp = customft_mac_round( tmp )
                mat_result[n][i][j] = tmp 
                
    mat_res_real = np.zeros((16,16), dtype=np.float32)
    mat_res_int = np.zeros((16,16), dtype=np.int32)
    for i in range(16):
        for j in range(16):
            mat_res_int[i][j] =  mat_result[-1,i,j]
            mat_res_real[i][j] = convert_int_to_ft( mat_result[-1,i,j] )

    # -----------------------------------------------------------------
    # compare
    # -----------------------------------------------------------------     
    diff_idx_real = np.where(mat_ref_real != mat_res_real) 
    diff_cor_real = [ (diff_idx_real[0][i], diff_idx_real[1][i]) for i in range(len(diff_idx_real[0])) ]
    diff_idx_int = np.where(mat_ref_int != mat_res_int) 
    diff_cor_int = [ (diff_idx_int[0][i], diff_idx_int[1][i]) for i in range(len(diff_idx_int[0])) ]
    print( "Are the different cordinate the same? ", diff_cor_real == diff_cor_int )
    print("The total number of different cordinates is {}.".format( len(diff_cor_int) ))
    

if __name__=='__main__':
    main()