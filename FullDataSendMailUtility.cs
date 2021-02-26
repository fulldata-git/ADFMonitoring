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

using Dapper;
using SendGrid;
using SendGrid.Helpers.Mail;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace MonitoringGit
{
    public class FullDataSendMailUtility
    {
        public async Task SendMailAsync(FullDataADFMonitoringModel model, TimeSpan duration, string key, int aDFThresholdModel)
        {

            var celiedDuration = Math.Ceiling(duration.TotalMinutes);
            var client = new SendGridClient(key);
            var from = new SendGrid.Helpers.Mail.EmailAddress("abc@fulldata.nl", "Dummy User");
            var subject = "ADF - long running ADF job detected";
            var toEmails = new List<EmailAddress>()
                {
                    new EmailAddress("receipient@fulldata.nl", "Dummy User")
                };

            // Customize body for Email
            var htmlContent = "Issue with Adf";

            var msg = MailHelper.CreateSingleEmailToMultipleRecipients(from, toEmails, subject, null, htmlContent);
            var response = await client.SendEmailAsync(msg);
        }
    }
}
