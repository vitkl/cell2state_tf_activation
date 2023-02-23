#import libraries
import os
import pandas as pd
import numpy as np
#read barcode grna mapping file
barcode_grna_mapping = pd.read_csv('/lustre/scratch123/hgi/teams/parts/kl11/cell2state_tf_activation/data/cloned_gRNA_constructs_w_barcode.csv')
#drop all column starting with Unnamed
barcode_grna_mapping = barcode_grna_mapping.loc[:, ~barcode_grna_mapping.columns.str.startswith('Unnamed')]
#in grna construct column replace regex r'+\d+' with ''
barcode_grna_mapping['gRNA construct'] = barcode_grna_mapping['gRNA construct'].str.replace(r'\+.+', '', regex=True)
#create new csv file
barcode_grna_mapping.to_csv('/lustre/scratch123/hgi/teams/parts/kl11/cell2state_tf_activation/data/cloned_gRNA_constructs_w_barcode.csv', index=False)