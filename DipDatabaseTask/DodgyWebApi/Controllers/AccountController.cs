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
    public class AccountController : ControllerBase
    {
        private readonly DipDatabaseTaskContext _context;

        public AccountController(DipDatabaseTaskContext context)
        {
            _context = context;
        }

        //api/account
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Clientaccount3815>>> GetAccounts()
        {
            return await _context.Clientaccount3815.ToListAsync();
        }

        //should be good for now
        [HttpGet("{id}")]
        public async Task<IEnumerable<ClientByID3815>> GetAccountID(int id)
        {
            var param = new SqlParameter("@PACCOUNTID", id);

            return await _context.ClientByID3815.FromSqlRaw("EXEC GET_CLIENT_ACCOUNT_BY_ID @PACCOUNTID", param).ToListAsync();
        }

        [HttpPost]

        public string PostAccount([FromBody] Clientaccount3815 value)
        {
            var pName = new SqlParameter("@PACCTNAME", value.Acctname);
            var pBal = new SqlParameter("@PBALANCE", value.Balance);
            var pCred = new SqlParameter("@PCREDITLIMIT", value.Creditlimit);

            try
            {
                _context.Database.ExecuteSqlRaw("EXEC ADD_CLIENT_ACCOUNT @PACCTNAME, @PBALANCE, @PCREDITLIMIT", pName, pBal, pCred);
            }
            catch (Exception e)
            {
                return e.Message;
            }

            return "Account added:" + pName.Value + " Balance: " + pBal.Value + " CreditLimit: " + pCred.Value;
        }
    }

    
}
