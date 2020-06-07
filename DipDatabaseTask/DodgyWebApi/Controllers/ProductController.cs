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
    public class ProductController : ControllerBase
    {
        private readonly DipDatabaseTaskContext _context;

        public ProductController(DipDatabaseTaskContext context)
        {
            _context = context;
        }

        // GET: api/Product
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Product3815>>> GetProducts()
        {
            return await _context.Product3815.ToListAsync();
        }

        //GET: api/product/id
        [HttpGet("{id}")]
        public async Task<ActionResult<IEnumerable<Product3815>>> GetProductID(string id)
        {
            var param = new SqlParameter("@PPRODID", id);

            return await _context.Product3815.FromSqlRaw("EXEC GET_PRODUCT_BY_ID @PPRODID", param).ToListAsync();

        }



        [HttpPost]
        // POST: api/Payment/
        public string PostProduct([FromBody] Product3815 value)
        {
            var pName = new SqlParameter("@PPRODNAME", value.Prodname);
            var pBuy = new SqlParameter("@PBUYPRICE", value.Buyprice);
            var pSell = new SqlParameter("@PSELLPRICE", value.Sellprice);

            try
            {
                _context.Database.ExecuteSqlRaw("EXEC ADD_PRODUCT @PPRODNAME, @PBUYPRICE, @PSELLPRICE", pName, pBuy, pSell);
            }
            catch (Exception e)
            {
                return e.Message;
            }

            return "product added:" + pName.Value + " BuyPrice: " + pBuy.Value + " SellPrice: " + pSell.Value;
        }

    }
}

