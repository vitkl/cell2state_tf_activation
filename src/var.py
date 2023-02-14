import datetime
import os
import seaborn as sns
import matplotlib.pyplot as plt
from IPython.display import set_matplotlib_formats

###Define constants here###

#Current date format is YYYYMMDD with automatically updated date
today = datetime.datetime.now().strftime("%Y%m%d")

#Define paths to data here
sc_data_folder = '/nfs/team205/vk7/sanger_projects/cell2state_tf_activation/data/pilot_5_prime_dec_2022/'
sc_data_w_cas9_seq_folder = '/lustre/scratch123/hgi/teams/parts/kl11/data/'

#Save results in the following folder (create if it doesn't exist)

results_folder = '/lustre/scratch123/hgi/teams/parts/kl11/cell2state_tf_activation/results/'
if not os.path.exists(results_folder):
    os.makedirs(results_folder)

color=sns.color_palette("colorblind", 10)

#create matplotlib default options for plots to be loaded into jupyter notebook

plt.rcParams['figure.dpi'] = 100 # 200 e.g. is really fine, but slower
plt.rcParams['savefig.dpi'] = 300 
#remove upper axis and right axis from all plots
plt.rcParams['axes.spines.top'] = False
plt.rcParams['axes.spines.right'] = False
#legend without frame
plt.rcParams['legend.frameon'] = False
set_matplotlib_formats('png','svg', 'pdf') # For export