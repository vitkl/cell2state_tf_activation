echo '---Start backing up data folder'

#rclone incremental backup
/software/rclone/rclone sync -iP /lustre/scratch123/hgi/teams/parts/kl11/cell2state_tf_activation/data gdrive:phd_rotation_2/data

echo 'Data folder successfully backed up---'

echo '---Start backing up analysis folder'

#rclone incremental backup
/software/rclone/rclone sync -iP /lustre/scratch123/hgi/teams/parts/kl11/cell2state_tf_activation/results gdrive:phd_rotation_2/results

echo 'Analysis folder successfully backed up---'