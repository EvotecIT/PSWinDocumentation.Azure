Add-Type -TypeDefinition @"
    using System;

    namespace PSWinDocumentation
    {
        [Flags]
        public enum Azure {
            VirtualMachines
        }
    }
"@