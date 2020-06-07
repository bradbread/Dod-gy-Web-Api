using System;
using System.Collections.Generic;

namespace DodgyWebApi.Models
{
    public partial class Clientaccount3815
    {
        public Clientaccount3815()
        {
            Accountpayment3815 = new HashSet<Accountpayment3815>();
            Authorisedperson3815 = new HashSet<Authorisedperson3815>();
        }

        public int Accountid { get; set; }
        public string Acctname { get; set; }
        public decimal Balance { get; set; }
        public decimal Creditlimit { get; set; }

        public virtual ICollection<Accountpayment3815> Accountpayment3815 { get; set; }
        public virtual ICollection<Authorisedperson3815> Authorisedperson3815 { get; set; }
    }
}
