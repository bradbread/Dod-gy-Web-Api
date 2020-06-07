using System;
using System.Collections.Generic;

namespace DodgyWebApi.Models
{
    public partial class Order3815
    {
        public Order3815()
        {
            Orderline3815 = new HashSet<Orderline3815>();
        }

        public int Orderid { get; set; }
        public string Shippingaddress { get; set; }
        public DateTime Datetimecreated { get; set; }
        public DateTime? Datetimedispatched { get; set; }
        public decimal Total { get; set; }
        public int Userid { get; set; }

        public virtual Authorisedperson3815 User { get; set; }
        public virtual ICollection<Orderline3815> Orderline3815 { get; set; }
    }
}
