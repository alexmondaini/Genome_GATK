version 1.0

struct FastqSample {
  File fastq_1
  File fastq_2
  String name
  String readgroup
  String library
}

workflow ConvertPairedFastQsToUnmappedBamWf {
  input {
    Array[FastqSample] samples
    String platform_name 
    String sequencing_center 
    String gatk_docker = "broadinstitute/gatk:latest"
    String gatk_path = "/gatk/gatk"
  }
  scatter (sample in samples) {
    #Convert pair of FASTQs to UBAM in parallel
    call PairedFastQsToUnmappedBAM {
      input:
      sample_name = sample.name,
      fastq_1 = sample.fastq_1,
      fastq_2 = sample.fastq_2,
      readgroup_name = sample.readgroup,
      library_name = sample.library,
      platform_name = platform_name,
      sequencing_center = sequencing_center,
      gatk_path = gatk_path,
      docker = gatk_docker
    }
  }
  # Outputs that will be retained when execution is complete
  output {
    Array[File] output_unmapped_bam = PairedFastQsToUnmappedBAM.output_unmapped_bam
  }
}


task PairedFastQsToUnmappedBAM {
  input {
    # command parameters
    String sample_name
    File fastq_1
    File fastq_2
    String readgroup_name
    String library_name
    String platform_name
    String sequencing_center
    # runtime parameters
    Int machine_mem_gb = 8
    Int n_cores = 4
    String gatk_path
    String docker
  }
  Int command_mem_gb = machine_mem_gb-2

  command {
    ~{gatk_path} --java-options "-Xmx~{command_mem_gb}G" \
    FastqToSam \
    --FASTQ  ~{fastq_1} \
    --FASTQ2 ~{fastq_2} \
    --OUTPUT ~{readgroup_name}.unmapped.bam \
    --READ_GROUP_NAME ~{readgroup_name} \
    --SAMPLE_NAME ~{sample_name} \
    --LIBRARY_NAME ~{library_name} \
    --PLATFORM ~{platform_name} \
    --SEQUENCING_CENTER ~{sequencing_center}
  }
  runtime {
    docker: docker
    memory: machine_mem_gb + " GB"
    cpu: n_cores
  }
  output {
    File output_unmapped_bam = "~{readgroup_name}.unmapped.bam"
  }
}