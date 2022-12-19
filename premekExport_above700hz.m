above_650Hz_ind = Tiedf.FRfreq>650;

data.s_f_above650hz =  loadfun(plt.loadSignalIED, Tiedf.Signal( above_700Hz_ind  )  );
data.f = Tiedf.FRfreq(above_650Hz_ind);
data.fs = 5000;

save('data')
