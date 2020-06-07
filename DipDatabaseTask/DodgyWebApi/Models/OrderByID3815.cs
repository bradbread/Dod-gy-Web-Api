using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace DodgyWebApi.Models
{
    public class OrderByID3815
    {
        public int Orderid { get; set; }
        public string Shippingaddress { get; set; }
        public DateTime Datetimecreated { get; set; }
        public DateTime? Datetimedispatched { get; set; }
        public int Userid { get; set; }
        public decimal Total { get; set; }
        public int Productid { get; set; }
        public int Quantity { get; set; }
        public decimal? Discount { get; set; }
        public decimal Subtotal { get; set; }
    }
}
