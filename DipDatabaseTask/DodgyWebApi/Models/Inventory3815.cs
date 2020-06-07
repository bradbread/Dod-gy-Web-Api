using System;
using System.Collections.Generic;

namespace DodgyWebApi.Models
{
    public partial class Inventory3815
    {
        public int Productid { get; set; }
        public string Locationid { get; set; }
        public int Numinstock { get; set; }

        public virtual Location3815 Location { get; set; }
        public virtual Product3815 Product { get; set; }
    }
}
