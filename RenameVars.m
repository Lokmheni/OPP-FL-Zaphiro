function[data] = RenameVars(data)

data = renamevars(data,"Var1","Line Number");
data = renamevars(data,"Var2","From Bus");
data = renamevars(data,"Var3","To Bus");
data = renamevars(data,"Var4","Length (km)");
data = renamevars(data,"Var5","Resistance (R1)*");
data = renamevars(data,"Var6","Reactance (X1)*");
data = renamevars(data,"Var7","Susceptance (B1)*");
data = renamevars(data,"Var8","Resistance (R0)");
data = renamevars(data,"Var9","Reactance (X0)");
data = renamevars(data,"Var10","Susceptance (B0)");
data = renamevars(data,"Var11","Ampacity");
data = renamevars(data,"Var12","Number of lines");
