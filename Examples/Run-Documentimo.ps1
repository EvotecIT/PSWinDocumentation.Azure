


$CompanyName = 'Evotec'

Documentimo -FilePath "$PSScriptRoot\Output\Azure-Documentation.docx" {
    DocToc -Title 'Table of content'

    DocPageBreak

    DocText {
        "This document provides documentation of Azure for $CompanyName."
    }
    DocNumbering -Text 'Azure Virtual Machines' -Level 0 -Type Numbered -Heading Heading1 {

        DocNumbering -Text 'Virtual Machines' -Level 1 -Type Numbered -Heading Heading1 {
            DocTable -DataTable $Azure.VirtualMachines
        }
    }
} -Open