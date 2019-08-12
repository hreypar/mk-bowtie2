# DESCRIPTION:
# mk module to filter single-end reads in FASTQ files
#
# USAGE:
# Single target execution: `mk <TARGET>` where TARGET is
# any line printed by the script `bin/mk-targets`
#
# Multiple target execution in tandem `bin/mk-targets | xargs mk`
#
# AUTHOR: HRG
#
# Align reads to the reference genome using Bowtie2
#
results/%.sam:   data/%.fastq.gz
	DIR="`dirname $target | sort -u`"
	mkdir -p "$DIR"
	&& mv $target.build $target

# Compress sam alignments
#
results/%.bam:	results/%.sam
	mkdir -p `dirname $target`
	samtools view \
		-h \
		-bS \
		$prereq \
	> $target.build \
	&& mv $target.build $target

# Sort bam alignment files
#
results/%.sorted.bam:	results/%.bam
	mkdir -p `dirname $target`
	java -jar $PICARD_TOOLS_PATH/SortSam.jar \
		INPUT=$prereq \
		OUTPUT=$target.build \
		SORT_ORDER=coordinate \
	&& mv $target.build $target

# Clean intermediate files
clean:V:
	find -L results/ \
		-type f \
		! -name "*.sorted.bam" \
	| xargs rm
