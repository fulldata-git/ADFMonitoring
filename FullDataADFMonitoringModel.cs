/*
███████████████████████████ FULLDATA.NL ██████████████████████████████

███████╗██╗   ██╗██╗     ██╗         ██████╗  █████╗ ████████╗ █████╗ 
██╔════╝██║   ██║██║     ██║         ██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗
█████╗  ██║   ██║██║     ██║         ██║  ██║███████║   ██║   ███████║
██╔══╝  ██║   ██║██║     ██║         ██║  ██║██╔══██║   ██║   ██╔══██║
██║     ╚██████╔╝███████╗███████╗    ██████╔╝██║  ██║   ██║   ██║  ██║
╚═╝      ╚═════╝ ╚══════╝╚══════╝    ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝
███████████████████████████ FULLDATA.NL ██████████████████████████████
*/

using System;
using System.Collections.Generic;
using System.Text;

namespace MonitoringGit
{
    public class FullDataADFMonitoringModel
    {
        public string FactoryName { get; set; }
        public string RunId { get; set; }
        public string DebugRunId { get; set; }
        public string RunGroupId { get; set; }
        public int? DurationInMs { get; set; }
        public string Status { get; set; }
        public string RunStart { get; set; }
        public string RunEnd { get; set; }
        public string Message { get; set; }
        public string LastUpdated { get; set; }
        public string PipelineName { get; set; }
    }
}
