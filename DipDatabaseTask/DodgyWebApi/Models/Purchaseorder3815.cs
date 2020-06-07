using System;
using System.Collections.Generic;

namespace DodgyWebApi.Models
{
    public partial class Purchaseorder3815
    {
        public int Productid { get; set; }
        public string Locationid { get; set; }
        public DateTime Datetimecreated { get; set; }
        public int? Quantity { get; set; }
        public decimal? Total { get; set; }

        public virtual Location3815 Location { get; set; }
        public virtual Product3815 Product { get; set; }
    }
}
