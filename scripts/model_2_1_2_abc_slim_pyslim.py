import tskit
import msprime
import pyslim
import random
import argparse



parser = argparse.ArgumentParser()
parser.add_argument('-i', help='Input TreeSeq')
parser.add_argument('-o', help='Output VCF')
parser.add_argument('-c', help='Chromosome name', default = "1")
parser.add_argument('--scale', help='Chromosome name', type = float)
args = parser.parse_args()


ts_name = args.i
vcf_name = args.o
chrom = args.c
scale = args.scale


# Load the SLiM TreeSeq
ts = tskit.load(ts_name)

# Recapitate
tsr = pyslim.recapitate(ts, ancestral_Ne=int(4.252830167e+05 / scale), recombination_rate = 4.6e-9 * scale)
#tsr.dump("model_2_1_2_posterior_med_recap.tree")

# All nodes in tsr
nodes = []
for pop in range(0,11):
    nodes_tmp = []
    for node in tsr.nodes():
        if(node.population == pop and node.is_sample()):
            nodes_tmp.append(node.id)
    nodes.append(nodes_tmp)

# Numbers of diploid inds to sample in VCF
ninds = [0, 12, 66, 12, 23, 10, 13, 13, 11, 9, 10]

# Make a list with all individuals per population
inds=[]
for pop in range(11):
    inds.append(list(set([tsr.node(node).individual for node in nodes[pop]])))


# Sample individuals
inds_keep = []
for pop in range(11):
    for ind in random.sample(inds[pop], ninds[pop]):
        inds_keep.append(ind)

# Based on the sampled individuals, determine which nodes to keep
nodes_keep = []
for ind in inds_keep:
    c=0
    for node in tsr.nodes():
        if node.individual == ind:
            nodes_keep.append(node.id)
            c+=1
        if c == 2:
            break

# Get TreeSeq for the sampled nodes
ts_sub = tsr.simplify(samples = nodes_keep)


# Throw mutations
tsm_sub = msprime.sim_mutations(ts_sub, rate = 4.6e-9 * scale)


# Save mutations in VCF
with open(vcf_name, "w") as vcf_file:
    tsm_sub.write_vcf(vcf_file, contig_id = chrom)

