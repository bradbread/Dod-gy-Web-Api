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
    public class PaymentController : ControllerBase
    {
        private readonly DipDatabaseTaskContext _context;

        public PaymentController(DipDatabaseTaskContext context)
        {
            _context = context;
        }

        //GET api/Payment
        [HttpGet]
                public async Task<ActionResult<IEnumerable<Accountpayment3815>>> GetAccountpayment3815()
        {
            return await _context.Accountpayment3815.ToListAsync();
        }


        // POST: api/Payment/id
        [HttpPost("{id}")]
        public string PostPayment(int id, [FromBody] decimal value)
        {
            var pId = new SqlParameter("@PACCOUNTID", id);
            var pAmount = new SqlParameter("@PAMOUNT", value);

            

            try
            {
                _context.Database.ExecuteSqlRaw("EXEC MAKE_ACCOUNT_PAYMENT @PACCOUNTID, @PAMOUNT", pId, pAmount);
            }
            catch (Exception e)
            {
                return e.Message;
            }

            return "payment made to account:" + pId.Value + " amount: " + pAmount.Value;
        }

    }
}
