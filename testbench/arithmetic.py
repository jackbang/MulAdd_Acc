
def parse_ft_bin( data_str, width_integer=7, width_fraction=9 ):
    data_str = data_str.replace("_","")
    the_int = data_str[0:width_integer]
    the_fra = data_str[width_integer:-1]
    data_int = int(the_int, 2)
    data_fra = int(the_fra, 2)
    return data_int, data_fra

def convert_str_to_int( data_str ):
    data_str = data_str.replace("_","")
    if data_str[0] == '1':
        diff_len = 32-len(data_str)
        the_str = '1'*diff_len + data_str
        tmp = ~(int(the_str, 2)-1)
        res = -1 * int(bin(tmp & 0xffffffff), 2)
    else:
        res = int( data_str, 2 ) 
    return res

def convert_int_to_str( data_int, width_integer=7, width_fraction=9 ):
    if data_int > 0 :
        data_bin = bin( data_int )[2:]
    else:
        data_bin = bin( data_int & 0xffffffff )
    tmp = data_bin[-(width_integer+width_fraction):]
    len_diff = (width_integer+width_fraction) - len(tmp)
    res = len_diff*"0" + tmp if (len_diff>0) else tmp     
    return res 

def convert_int_to_ft( data, width_integer=7, width_fraction=9 ):
    sign_neg = data<0
    the_data = data if sign_neg == False else -data
    data_fraction = the_data & int("1"*width_fraction, 2)
    data_integer = (the_data>>width_fraction) & int("1"*width_integer, 2)
    data_final = data_integer + data_fraction/(2**(width_fraction))
    data_final = -1 * data_final if sign_neg else data_final
    return data_final

def convert_real_to_int( data, width_integer=7, width_fraction=9 ):
    res = round( data * (2**width_fraction) )
    return res

def customft_mac_mul( op1, op2, width_integer=7, width_fraction=9 ):
    return op1*op2 

def customft_mac_add( op1, op2, width_integer=7, width_fraction=9 ):
    return op1+op2 

def customft_mac_round( op, width_integer=7, width_fraction=9 ):
    # op_binary = bin( op & 0xffffffff )
    raw_integer = (op>>(2*width_fraction))
    raw_fraction = op & int("1"*width_fraction*2, 2)

    save_last = (op>>(width_fraction)) & 1
    drop_first = (op>>(width_fraction-1)) & 1
    drop_rest = op & int("1"*(width_fraction-1),2)
    flag_nonzero = drop_rest != 0

    # round to nearest
    # if flag_nonzero:
    #     carry = drop_first 
    # else: # 0.50
    #     carry = drop_first & save_last
    
    # round 5 up 5 off
    carry = drop_first

    res_unround = (raw_integer<<width_fraction) | (raw_fraction>>width_fraction)
    result = res_unround + carry 

    underflow = op < (-2**(width_integer+2*width_fraction-1))
    overflow = op > ( 2**(width_integer+2*width_fraction-1)-1 )
    if overflow:
        result = 2**(width_integer+width_fraction-1)-1
    elif underflow:
        result = -2**(width_integer+width_fraction-1)
    
    return result 