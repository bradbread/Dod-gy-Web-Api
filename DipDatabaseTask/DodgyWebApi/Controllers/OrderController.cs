using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Xml.Linq;
using DodgyWebApi.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;

namespace DodgyWebApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class OrderController : ControllerBase
    {
        private readonly DipDatabaseTaskContext _context;

        public OrderController(DipDatabaseTaskContext context)
        {
            _context = context;
        }

        // GET: api/Order
        [HttpGet]
        public IEnumerable<Order3815> GetOpenOrders()
        {
            return _context.Order3815.FromSqlRaw("EXEC GET_OPEN_ORDERS").ToList();
        }

        //fix
        // GET: api/Order/5
        [HttpGet("{id}")]
        public async Task<IEnumerable<OrderByID3815>> GetOrderID(int id)
        {
            var pId = new SqlParameter("@PORDERID", id);

            return await _context.OrderByID3815.FromSqlRaw("EXEC GET_ORDER_BY_ID @PORDERID", pId).ToListAsync();
        }

        // POST: api/Order
        [HttpPost]
        public string PostOrder([FromBody] Order3815 value)
        {
            var pId = new SqlParameter("@PUSERID", value.Userid);
            var pAdd = new SqlParameter("@PSHIPPINGADDRESS", value.Shippingaddress);

            try
            {
                _context.Database.ExecuteSqlRaw("EXEC CREATE_ORDER @PSHIPPINGADDRESS, @PUSERID", pAdd, pId);
            }
            catch (Exception e)
            {
                return e.Message;
            }

            return "order created userid:" + pId.Value + " address: " + pAdd.Value;
        }

        [HttpPut]
        public string FillOrder([FromBody] int orderid)
        {
            var pId = new SqlParameter("@PUSERID", orderid);

            try
            {
                _context.Database.ExecuteSqlRaw("EXECFULFILL_ORDER @PORDERID", pId);
            }
            catch (Exception e)
            {
                return e.Message;
            }

            return "order fuullfilled: " + pId.Value;
        }

    }
}
