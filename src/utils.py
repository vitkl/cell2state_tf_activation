#function to plot histogram of sgRNA counts per cell and save as pdf
def plot_histogram(df ,col ,num_bins, xlabel, ylabel, results_folder, today, figname):
    import matplotlib.pyplot as plt
    
    """
    Plot histogram with x and y label and save as pdf
    Parameters
    ----------
    df : pd.Dataframe
        Dataframe with column to plot histogram of
    col : str
        Column name of dataframe to plot histogram of
    num_bins : int
        Number of bins for histogram
    xlabel : str
        Label for x axis
    ylabel : str
        Label for y axis
    results_folder : str
        path to folder to save histogram as pdf
    today : str
        current date
    Returns
    -------
    None
    """
    plt.hist(df[col],bins=num_bins);
    plt.xlabel(xlabel);
    plt.ylabel(ylabel);

    plt.axvline(x=1000, color='r', linestyle='--')
    plt.show()
    plt.savefig(f'{results_folder}{today}_{figname}.pdf', bbox_inches='tight')