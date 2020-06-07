using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using DodgyWebApi.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json.Schema;

namespace DodgyWebApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthorisedPersonController : ControllerBase
    {
        private readonly DipDatabaseTaskContext _context;

        public AuthorisedPersonController(DipDatabaseTaskContext context)
        {
            _context = context;
        }

        // POST: api/AuthorisedPerson
        [HttpPost]
        public string Post([FromBody] Authorisedperson3815 value)
        {
            var pFName = new SqlParameter("@PFIRSTNAME", value.Firstname);
            var pSurname = new SqlParameter("@PSURNAME", value.Surname);
            var pEmail = new SqlParameter("@PEMAIL", value.Email);
            var pPass = new SqlParameter("@PPASSWORD", value.Password);
            var pID = new SqlParameter("@PACCOUNTID", value.Accountid);

            try
            {
                _context.Database.ExecuteSqlRaw("EXEC ADD_AUTHORISED_PERSON @PFIRSTNAME, @PSURNAME, @PEMAIL, @PPASSWORD, @PACCOUNTID", pFName, pSurname, pEmail, pPass, pID);
            }
            catch (Exception e)
            {
                return e.Message;
            }

            return "authorised person added:" + pFName + pSurname + " to ClientAccount: " + pID;
        }

    }
}
