import datetime
import os
import seaborn as sns

###Define constants here###

#Current date format is YYYYMMDD with automatically updated date
today = datetime.datetime.now().strftime("%Y%m%d")

#Define paths to data here
sc_data_folder = '/nfs/team205/vk7/sanger_projects/cell2state_tf_activation/data/pilot_5_prime_dec_2022/'

#Save results in the following folder (create if it doesn't exist)

results_folder = '/lustre/scratch123/hgi/teams/parts/kl11/cell2state_tf_activation/results/'
if not os.path.exists(results_folder):
    os.makedirs(results_folder)

color=sns.color_palette("colorblind", 10)