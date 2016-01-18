function newind = findindperucmd(time,ucmd)

for t=1:length(time);
[~,newind(t)] = min(abs(ucmd.timeinsec - time(t)));
end
