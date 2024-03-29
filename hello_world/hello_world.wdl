version 1.0

workflow HelloWorld {

    input {
        File hello
    }

    call WriteGreeting {
        input:
        hello = hello
    }
}

task WriteGreeting {
    input {
        File hello
    }
    command {
        cat ~{hello}
    }
    output {
        File output_greeting = stdout()
    }
}
