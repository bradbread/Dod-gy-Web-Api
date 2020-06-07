using System;
using System.Collections.Generic;

namespace DodgyWebApi.Models
{
    public partial class Authorisedperson3815
    {
        public Authorisedperson3815()
        {
            Order3815 = new HashSet<Order3815>();
        }

        public int Userid { get; set; }
        public string Firstname { get; set; }
        public string Surname { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public int Accountid { get; set; }

        public virtual Clientaccount3815 Account { get; set; }
        public virtual ICollection<Order3815> Order3815 { get; set; }

    }
}
