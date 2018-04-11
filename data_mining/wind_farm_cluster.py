# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import random
from sklearn.cluster import KMeans
from sklearn.decomposition import PCA
from sklearn.metrics import silhouette_samples,silhouette_score

npc = np.load('/home/t630/Voltage_Control/data/2015AGC/numpy_data/npwithoutnan2.npy')
uselesslist = [18,21,22,27,34,43,44,53,56,57,58]
l = []
for i in range(1,58):
    if i not in uselesslist:
        l.append(i)
df_names =  pd.read_excel('/home/t630/Voltage_Control/data/2015AGC/0场站名称.xlsx',header=None)
pdc = pd.DataFrame(npc)
l_capacity = []
for i in l:
    l_capacity.append(round(df_names[4][i-1],1))


npc_c = npc[:,1:].T
npc_c = npc_c/np.array(l_capacity).reshape((47,1))
npc_c_mean = np.mean(npc_c,axis = 1)
npc_c = npc_c - npc_c_mean.reshape((47,1))
kmeans =  KMeans(n_clusters=8,max_iter=30000,n_jobs = 8)
kmeans.fit(npc_c)
print(kmeans.labels_)
print(kmeans.inertia_)
print(silhouette_score(npc_c+npc_c_mean.reshape((47,1)), kmeans.labels_))

'''
# tsne to plot
from sklearn.manifold import TSNE
tsne =  TSNE()
npc_tsne = tsne.fit_transform(npc_c)
color_list = ['k^','r*','mo','y>','g*','co','bo','b<']
for i in range(47):
    plt.plot(npc_tsne[i,0],npc_tsne[i,1],color_list[kmeans.labels_[i]])
plt.show()

labels = kmeans.labels_
#plot after cluster
numtoplot = 2000
plt.figure()
for i in range(47):
    plt.plot(range(numtoplot),npc[:numtoplot,i+1]/npc[:numtoplot,i+1].max())
plt.show()


for i in range(8):
    plt.figure()
    for j in np.where(labels==i):
        plt.plot(range(numtoplot),npc[:numtoplot,j+1]/npc[:numtoplot,j+1].max())
    plt.title('cluster: '+str(i))
    plt.show()
    
    

       
# talking about the numbers to clusters
c_inertias = []
for i in range(2,20):
    kmeansi = KMeans(n_clusters=i,max_iter=3000,n_jobs=8)
    kmeansi.fit(npc_c)
    #print(kmeansi.labels_)
    #print(kmeansi.inertia_)
    print(silhouette_score(npc_c,kmeansi.labels_))
    c_inertias.append(kmeansi.inertia_)
plt.plot(range(2,20),c_inertias)







#********降维**************
#random select
n,m = npc.shape
allindex = range(n)
random.shuffle(allindex)
numtoselect = 1000
selectindex = allindex[:1000]
selectindex.sort()
npc_s = npc[selectindex,:]
npc_s = npc_s[:,1:]
for i in range(47):
    plt.figure()
    plt.plot(range(numtoselect),npc_s[:,i]/npc_s[:,i].max())
    plt.title(str(i))
    plt.show()

npc_sc = npc_s.T
npc_sc = npc_sc/np.array(l_capacity).reshape((47,1))
npc_sc_mean = np.mean(npc_sc,axis = 1)
npc_sc = npc_sc - npc_sc_mean.reshape((47,1))
kmeans_rs =  KMeans(n_clusters=8,max_iter=30000,n_jobs = 8)
kmeans_rs.fit(npc_sc)
print(kmeans_rs.labels_)
print(kmeans_rs.inertia_)
'''
#PCA
pca = PCA(n_components = 10)
pca.fit(npc_c)
npc_pca = pca.transform(npc_c)
kmeans_pca = KMeans(n_clusters=8,max_iter=30000,n_jobs = 8)
kmeans_pca.fit(npc_pca)
labels = kmeans_pca.labels_
for i in range(8):
    plt.figure()
    for j in np.where(labels==i):
        plt.plot(range(numtoplot),npc[:numtoplot,j+1]/npc[:numtoplot,j+1].max())
    plt.title('cluster: '+str(i))
    plt.show()
npc_inverse = pca.inverse_transform(npc_pca)
npc_inverse = npc_inverse+npc_c_mean.reshape((47,1))
npc_inverse = npc_inverse*np.array(l_capacity).reshape((47,1))
for i in range(47):
    plt.figure()
    plt.plot(range(numtoplot),npc[:numtoplot,i+1]/npc[:numtoplot,i+1].max())
    plt.plot(range(numtoplot),npc_inverse[i,:numtoplot]/npc_inverse[i,:numtoplot].max())
    plt.title('cluster: '+str(i))
    plt.show()






