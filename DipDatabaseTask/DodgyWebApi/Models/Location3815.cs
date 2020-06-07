using System;
using System.Collections.Generic;

namespace DodgyWebApi.Models
{
    public partial class Location3815
    {
       /*
        public Location3815(string pLocId, string pLocName, string pAddress, string pManager)
        {
            Inventory3815 = new HashSet<Inventory3815>();
            Purchaseorder3815 = new HashSet<Purchaseorder3815>();
            Locationid = pLocId;
            Locname = pLocName;
            Address = pAddress;
            Manager = pManager;
        }
        */
        
        public Location3815()
        {
            Inventory3815 = new HashSet<Inventory3815>();
            Purchaseorder3815 = new HashSet<Purchaseorder3815>();
        }
        

        public string Locationid { get; set; }
        public string Locname { get; set; }
        public string Address { get; set; }
        public string Manager { get; set; }

        public virtual ICollection<Inventory3815> Inventory3815 { get; set; }
        public virtual ICollection<Purchaseorder3815> Purchaseorder3815 { get; set; }
    }
}
