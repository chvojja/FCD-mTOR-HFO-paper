function recomputeFreq_Tiedhfo( Tied, Tiedhfo , fname )
% fname is a name under which it should be saved
% 
fs = 5000;
filteringfun_R = @(x,x1,x2) filtergauss(X = x, BandPass = [80 200]); 

[b,~] = favouritefilters('bpfastripples',fs);
filteringfun_FR = @(x,x1,x2)filtfilt(b,1,x);

[r,~] = size(Tiedhfo);
for ir = 1:r
     
       s =  loadfun(plt.loadSignalIED, Tied.Signal( ir )  );


       if Tiedhfo.HasR(ir) 
          [f,absH,faxis]= getFreqStockwell( filteringfun_R(s)  ,fs,40,250);
          Tiedhfo.Rfreq(ir) = f;
       end

       if Tiedhfo.HasFR(ir) 
          [f,absH,faxis]= getFreqStockwell( filteringfun_FR(s) ,fs,250,900);
          Tiedhfo.FRfreq(ir) = f;
       end

   
     a.verboser.sprintf2('ProgressPerc',round(100*ir/r),'HFO recomputing');
end


eval([fname ' = Tiedhfo']);
save7fp = a.pwd([fname '.mat']); save7
