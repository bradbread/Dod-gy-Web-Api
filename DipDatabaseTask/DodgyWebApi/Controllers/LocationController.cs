using System;
using System.Collections.Generic;
using System.Data;
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
    public class LocationController : ControllerBase
    {
        private readonly DipDatabaseTaskContext _context;

        public LocationController(DipDatabaseTaskContext context)
        {
            _context = context;
        }
        // GET: api/Location
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Location3815>>> GetLocation()
        {
            return await _context.Location3815.ToListAsync();
        }

        // GET: api/Location/5
        [HttpGet("{id}", Name = "Get")]
        public async Task<ActionResult<IEnumerable<Location3815>>> Get(string id)
        {
            var param = new SqlParameter("@PLOCID", id);

           return await _context.Location3815.FromSqlRaw("EXEC GET_LOCATION_BY_ID @PLOCID", param).ToListAsync();

        }

        // if extra time try and make this async
        // POST: api/Location
        [HttpPost]
        public string Post([FromBody] Location3815 value)
        {
            var pId = new SqlParameter("@PLOCID", value.Locationid);
            var pLocName = new SqlParameter("@PLOCNAME", value.Locname);
            var pLocAdd = new SqlParameter("@PLOCADDRESS", value.Address);
            var pManager = new SqlParameter("@PMANAGER", value.Manager);

            try
            {
                _context.Database.ExecuteSqlRaw("EXEC ADD_LOCATION @PLOCID, @PLOCNAME, @PLOCADDRESS, @PMANAGER", pId, pLocName, pLocAdd, pManager);
            }
            catch (Exception e)
            {
                return e.Message;
            }

            return "added new location";
        }

    }
}
