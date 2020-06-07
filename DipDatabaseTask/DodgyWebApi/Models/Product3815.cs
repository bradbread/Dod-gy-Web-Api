using System;
using System.Collections.Generic;

namespace DodgyWebApi.Models
{
    public partial class Product3815
    {
        public Product3815()
        {
            Inventory3815 = new HashSet<Inventory3815>();
            Orderline3815 = new HashSet<Orderline3815>();
            Purchaseorder3815 = new HashSet<Purchaseorder3815>();
        }

        public int Productid { get; set; }
        public string Prodname { get; set; }
        public decimal? Buyprice { get; set; }
        public decimal? Sellprice { get; set; }

        public virtual ICollection<Inventory3815> Inventory3815 { get; set; }
        public virtual ICollection<Orderline3815> Orderline3815 { get; set; }
        public virtual ICollection<Purchaseorder3815> Purchaseorder3815 { get; set; }
    }
}
