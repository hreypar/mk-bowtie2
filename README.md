# mk-bowtie2 #

Align reads to a reference genome using [Bowtie2](http://bowtie-bio.sourceforge.net/bowtie2/index.shtml)


[SortSam](https://software.broadinstitute.org/gatk/documentation/tooldocs/4.0.0.0/picard_sam_SortSam.php) (from Picard Tools).

## alignment scores ##

(from the bowtie manual)

An alignment score quantifies how similar the read sequence is to the reference sequence aligned to. The higher the score, the more similar they are. A score is calculated by subtracting penalties for each difference (mismatch, gap, etc.) and, in local alignment mode, adding bonuses for each match.

### Local alignment score example ###

A mismatched base at a high-quality position in the read receives a penalty of -6 by default. A length-2 read gap receives a penalty of -11 by default (-5 for the gap open, -3 for the first extension, -3 for the second extension). A base that matches receives a bonus of +2 be default. Thus, in local alignment mode, if the read is 50 bp long and it matches the reference exactly except for one mismatch at a high-quality position and one length-2 read gap, then the overall score equals the total bonus, 2 * 49, minus the total penalty, 6 + 11, = 81.

The best possible score in local mode equals the match bonus times the length of the read. This happens when there are no differences between the read and the reference.

### Minimum score threshold ###

Valid alignments meet or exceed the minimum score threshold
For an alignment to be considered “valid” (i.e. “good enough”) by Bowtie 2, it must have an alignment score no less than the minimum score threshold. The threshold is configurable and is expressed as a function of the read length. In end-to-end alignment mode, the default minimum score threshold is -0.6 + -0.6 * L, where L is the read length. In local alignment mode, the default minimum score threshold is 20 + 8.0 * ln(L), where L is the read length.

### Mapping Quality ###

The aligner cannot always assign a read to its point of origin with high confidence. For instance, a read that originated inside a repeat element might align equally well to many occurrences of the element throughout the genome, leaving the aligner with no basis for preferring one over the others.

Aligners characterize their degree of confidence in the point of origin by reporting a mapping quality: a non-negative integer Q = -10 log10 p, where p is an estimate of the probability that the alignment does not correspond to the read’s true point of origin. Mapping quality is sometimes abbreviated MAPQ, and is recorded in the SAM MAPQ field.

Mapping quality is related to “uniqueness.” We say an alignment is unique if it has a much higher alignment score than all the other possible alignments. The bigger the gap between the best alignment’s score and the second-best alignment’s score, the more unique the best alignment, and the higher its mapping quality should be.

