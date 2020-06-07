using System;
using System.Collections.Generic;

namespace DodgyWebApi.Models
{
    public partial class Accountpayment3815
    {
        public int Accountid { get; set; }
        public DateTime Datetimereceived { get; set; }
        public decimal Amount { get; set; }

        public virtual Clientaccount3815 Account { get; set; }
    }
}
