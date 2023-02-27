#import libraries
import os
import pandas as pd
import numpy as np
#read barcode grna mapping file
barcode_grna_mapping = pd.read_csv('/lustre/scratch123/hgi/teams/parts/kl11/cell2state_tf_activation/data/cloned_gRNA_constructs_w_barcode.csv')


### 1. Data wrangling and tidying for the barcode grna mapping file ###

#drop all column starting with Unnamed
barcode_grna_mapping = barcode_grna_mapping.loc[:, ~barcode_grna_mapping.columns.str.startswith('Unnamed')]
#in grna construct column replace regex r'+\d+' with ''
barcode_grna_mapping['gRNA construct'] = barcode_grna_mapping['gRNA construct'].str.replace(r'\+.+', '', regex=True)

### 2.  Add plasmid sequence to barcode aiming to mitigate spurious alignments to random sequence ###

#required length of plasmid sequence
total_barcode_length = 20
# 5' plasmid sequence
plasmid_seq_5 = 'ggccgcctccccgcaggtac'
plasmid_seq_5 = plasmid_seq_5.upper()
# check if length of plasmid sequence is equal to required length
assert len(plasmid_seq_5) == total_barcode_length, 'Length of plasmid sequence is not equal to required length'
#replace np.nan with empty string in barcode column
barcode_grna_mapping['Barcode'] = barcode_grna_mapping['Barcode'].replace(np.nan, '', regex=True)

def add_plasmid_seq(df,plasmid_seq_5):
    '''
    Parameters
    ----------
    df : dataframe containing barcode column
    plasmid_seq_5 : 5' plasmid sequence

    Returns
    -------
    complete_barcode : list of complete barcode sequence with plasmid sequence added
    
        Description.
    Function to add plasmid sequence to provide as input for parse_barcodes.py
    '''
    #iterate through each row in the dataframe
    complete_barcode = []
    for barcode in df['Barcode']:

        if (len(barcode)<20) & (len(barcode)>0):
            
            #remove sequence on 5' end of plasmid sequence
            plasmid_seq_5_added = plasmid_seq_5[len(barcode):]
            #add barcode sequence
            plasmid_seq_5_added = plasmid_seq_5_added + barcode
            #add to list
            complete_barcode.append(plasmid_seq_5_added)
        else:
            #add barcode sequence
            complete_barcode.append(barcode)
    
    return complete_barcode

#create new column with complete barcode sequence
complete_barcode = add_plasmid_seq(barcode_grna_mapping, plasmid_seq_5)
barcode_grna_mapping['complete_barcode'] = complete_barcode
#drop nan entries in complete_barcode column
barcode_grna_mapping = barcode_grna_mapping[barcode_grna_mapping['complete_barcode']!='']

#select only required columns
barcode_grna_mapping = barcode_grna_mapping[['complete_barcode','gRNA construct']]
#rename columns to match input for parse_barcodes.py script: gRNA_construct: Name, complete_barcode: Barcode
barcode_grna_mapping = barcode_grna_mapping.rename(columns={'gRNA construct':'NAME', 'complete_barcode':'BARCODE'})


#create new csv file
barcode_grna_mapping.to_csv('/lustre/scratch123/hgi/teams/parts/kl11/cell2state_tf_activation/data/cloned_gRNA_constructs_w_barcode_processed.csv', index=False)