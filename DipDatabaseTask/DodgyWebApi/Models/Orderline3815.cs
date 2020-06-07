using System;
using System.Collections.Generic;

namespace DodgyWebApi.Models
{
    public partial class Orderline3815
    {
        public int Orderid { get; set; }
        public int Productid { get; set; }
        public int Quantity { get; set; }
        public decimal? Discount { get; set; }
        public decimal Subtotal { get; set; }

        public virtual Order3815 Order { get; set; }
        public virtual Product3815 Product { get; set; }
    }
}
