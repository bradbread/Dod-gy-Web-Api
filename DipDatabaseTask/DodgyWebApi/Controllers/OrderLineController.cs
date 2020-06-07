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
    public class OrderLineController : ControllerBase
    {
        private readonly DipDatabaseTaskContext _context;

        public OrderLineController(DipDatabaseTaskContext context)
        {
            _context = context;
        }

        // POST: api/OrderLine
        [HttpPost]
        public string PostOrderLine([FromBody] Orderline3815 value)
        {
            var pOrderID = new SqlParameter("@PORDERID", value.Orderid);
            var pProdID = new SqlParameter("@PPRODID", value.Productid);
            var pQty = new SqlParameter("@PQTY", value.Quantity);
            var pDiscount = new SqlParameter("@DISCOUNT", value.Discount);

            try
            {
                _context.Database.ExecuteSqlRaw("EXEC ADD_PRODUCT_TO_ORDER @PORDERID, @PPRODID, @PQTY, @DISCOUNT", pOrderID, pProdID, pQty, pDiscount);
            }
            catch (Exception e)
            {
                return e.Message;
            }

            return "added new product: " + pProdID + " to order: " + pOrderID;

        }


        // DELETE: api/ApiWithActions/5
        [HttpDelete]
        public string DeleteProdFromOrder(Orderline3815 value)
        {
            var pOrderID = new SqlParameter("@PORDERID", value.Orderid);
            var pProdID = new SqlParameter("@PPRODID", value.Productid);

            try
            {
                _context.Database.ExecuteSqlRaw("EXEC REMOVE_PRODUCT_TO_ORDER @PORDERID, @PPRODID", pOrderID, pProdID);
            }
            catch (Exception e)
            {
                return e.Message;
            }

            return "removed product: " + pProdID + " from order: " + pOrderID;
        }
    }
}
