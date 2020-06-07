using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using DodgyWebApi.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;

namespace DodgyWebApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PurchaseController : ControllerBase
    {
        private readonly DipDatabaseTaskContext _context;

        public PurchaseController(DipDatabaseTaskContext context)
        {
            _context = context;
        }

        // POST: api/Purchase
        [HttpPost]
        public string PostPurchaseStock([FromBody] Inventory3815 value)
        {
            var pProdID = new SqlParameter("@PPRODID", value.Productid);
            var pLoc = new SqlParameter("@PLOCID", value.Locationid);
            var pQty = new SqlParameter("@PQTY", value.Numinstock);

            try
            {
                _context.Database.ExecuteSqlRaw("EXEC PURCHASE_STOCK @PPRODID, @PLOCID, @PQTY", pProdID, pLoc, pQty);
            }
            catch (Exception e)
            {
                return e.Message;
            }

            return "product purchase:" + pProdID.Value + " Location: " + pLoc.Value + " Amount: " + pQty.Value;
        }
    }

}
