using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;

namespace DodgyWebApi.Models
{
    public partial class DipDatabaseTaskContext : DbContext
    {
        public DipDatabaseTaskContext()
        {
        }

        public DipDatabaseTaskContext(DbContextOptions<DipDatabaseTaskContext> options)
            : base(options)
        {
        }

        public virtual DbSet<Accountpayment3815> Accountpayment3815 { get; set; }
        public virtual DbSet<Authorisedperson3815> Authorisedperson3815 { get; set; }
        public virtual DbSet<Clientaccount3815> Clientaccount3815 { get; set; }
        public virtual DbSet<ClientByID3815> ClientByID3815 { get; set; }
        public virtual DbSet<Generalledger3815> Generalledger3815 { get; set; }
        public virtual DbSet<Inventory3815> Inventory3815 { get; set; }
        public virtual DbSet<Location3815> Location3815 { get; set; }
        public virtual DbSet<Order3815> Order3815 { get; set; }
        public virtual DbSet<OrderByID3815> OrderByID3815 { get; set; }
        public virtual DbSet<Orderline3815> Orderline3815 { get; set; }
        public virtual DbSet<Product3815> Product3815 { get; set; }
        public virtual DbSet<Purchaseorder3815> Purchaseorder3815 { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. See http://go.microsoft.com/fwlink/?LinkId=723263 for guidance on storing connection strings.
                optionsBuilder.UseSqlServer("Data Source=(localdb)\\ProjectsV13;Initial Catalog=DipDatabaseTask;Integrated Security=True;Connect Timeout=30;Encrypt=False;TrustServerCertificate=False;ApplicationIntent=ReadWrite;MultiSubnetFailover=False");
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Accountpayment3815>(entity =>
            {
                entity.HasKey(e => new { e.Accountid, e.Datetimereceived })
                    .HasName("PK_ACCOUNTPAYMENT");

                entity.ToTable("ACCOUNTPAYMENT3815");

                entity.Property(e => e.Accountid).HasColumnName("ACCOUNTID");

                entity.Property(e => e.Datetimereceived)
                    .HasColumnName("DATETIMERECEIVED")
                    .HasColumnType("datetime");

                entity.Property(e => e.Amount)
                    .HasColumnName("AMOUNT")
                    .HasColumnType("money");

                entity.HasOne(d => d.Account)
                    .WithMany(p => p.Accountpayment3815)
                    .HasForeignKey(d => d.Accountid)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_ACCOUNTPAYMENT_ACCOUNT");
            });

            modelBuilder.Entity<Authorisedperson3815>(entity =>
            {
                entity.HasKey(e => e.Userid)
                    .HasName("PK_AUTHORISEDPERSON");

                entity.ToTable("AUTHORISEDPERSON3815");

                entity.Property(e => e.Userid).HasColumnName("USERID");

                entity.Property(e => e.Accountid).HasColumnName("ACCOUNTID");

                entity.Property(e => e.Email)
                    .IsRequired()
                    .HasColumnName("EMAIL")
                    .HasMaxLength(100);

                entity.Property(e => e.Firstname)
                    .IsRequired()
                    .HasColumnName("FIRSTNAME")
                    .HasMaxLength(100);

                entity.Property(e => e.Password)
                    .IsRequired()
                    .HasColumnName("PASSWORD")
                    .HasMaxLength(100);

                entity.Property(e => e.Surname)
                    .IsRequired()
                    .HasColumnName("SURNAME")
                    .HasMaxLength(100);

                entity.HasOne(d => d.Account)
                    .WithMany(p => p.Authorisedperson3815)
                    .HasForeignKey(d => d.Accountid)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_AUTHORISEDPERSON_CLIENTACCOUNT");
            });

            modelBuilder.Entity<Clientaccount3815>(entity =>
            {
                entity.HasKey(e => e.Accountid)
                    .HasName("PK_CLIENTACCOUNT");

                entity.ToTable("CLIENTACCOUNT3815");

                entity.HasIndex(e => e.Acctname)
                    .HasName("UQ_CLENTACCOUNT_NAME")
                    .IsUnique();

                entity.Property(e => e.Accountid).HasColumnName("ACCOUNTID");

                entity.Property(e => e.Acctname)
                    .IsRequired()
                    .HasColumnName("ACCTNAME")
                    .HasMaxLength(100);

                entity.Property(e => e.Balance)
                    .HasColumnName("BALANCE")
                    .HasColumnType("money");

                entity.Property(e => e.Creditlimit)
                    .HasColumnName("CREDITLIMIT")
                    .HasColumnType("money");

            });

            //shouuld be a better way to do this
            modelBuilder.Entity<ClientByID3815>(entity =>
            {
                entity.HasKey(e => e.Accountid)
                    .HasName("PK_CLIENTACCOUNT");

                //entity.ToTable("CLIENTACCOUNT3815");

                entity.HasIndex(e => e.Acctname)
                    .HasName("UQ_CLENTACCOUNT_NAME")
                    .IsUnique();

                entity.Property(e => e.Accountid).HasColumnName("ACCOUNTID");

                entity.Property(e => e.Acctname)
                    .IsRequired()
                    .HasColumnName("ACCTNAME")
                    .HasMaxLength(100);

                entity.Property(e => e.Balance)
                    .HasColumnName("BALANCE")
                    .HasColumnType("money");

                entity.Property(e => e.Creditlimit)
                    .HasColumnName("CREDITLIMIT")
                    .HasColumnType("money");

                entity.HasKey(e => e.Userid)
            .   HasName("PK_AUTHORISEDPERSON");

                //entity.ToTable("AUTHORISEDPERSON3815");

                entity.Property(e => e.Userid).HasColumnName("USERID");

                entity.Property(e => e.Accountid).HasColumnName("ACCOUNTID");

                entity.Property(e => e.Email)
                    .IsRequired()
                    .HasColumnName("EMAIL")
                    .HasMaxLength(100);

                entity.Property(e => e.Firstname)
                    .IsRequired()
                    .HasColumnName("FIRSTNAME")
                    .HasMaxLength(100);

                entity.Property(e => e.Password)
                    .IsRequired()
                    .HasColumnName("PASSWORD")
                    .HasMaxLength(100);

                entity.Property(e => e.Surname)
                    .IsRequired()
                    .HasColumnName("SURNAME")
                    .HasMaxLength(100);
            });

            modelBuilder.Entity<Generalledger3815>(entity =>
            {
                entity.HasKey(e => e.Itemid)
                    .HasName("PK_GENERALLEDGER");

                entity.ToTable("GENERALLEDGER3815");

                entity.HasIndex(e => e.Description)
                    .HasName("UQ_GENERALEDGER_DESCRIPTION")
                    .IsUnique();

                entity.Property(e => e.Itemid)
                    .HasColumnName("ITEMID")
                    .ValueGeneratedNever();

                entity.Property(e => e.Amount)
                    .HasColumnName("AMOUNT")
                    .HasColumnType("money");

                entity.Property(e => e.Description)
                    .HasColumnName("DESCRIPTION")
                    .HasMaxLength(100);
            });

            modelBuilder.Entity<Inventory3815>(entity =>
            {
                entity.HasKey(e => new { e.Productid, e.Locationid })
                    .HasName("PK_INVENTORY");

                entity.ToTable("INVENTORY3815");

                entity.Property(e => e.Productid).HasColumnName("PRODUCTID");

                entity.Property(e => e.Locationid)
                    .HasColumnName("LOCATIONID")
                    .HasMaxLength(8);

                entity.Property(e => e.Numinstock).HasColumnName("NUMINSTOCK");

                entity.HasOne(d => d.Location)
                    .WithMany(p => p.Inventory3815)
                    .HasForeignKey(d => d.Locationid)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_INVENTORY_LOCATION");

                entity.HasOne(d => d.Product)
                    .WithMany(p => p.Inventory3815)
                    .HasForeignKey(d => d.Productid)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_INVENTORY_PRODUCT");
            });

            modelBuilder.Entity<Location3815>(entity =>
            {
                entity.HasKey(e => e.Locationid)
                    .HasName("PK_LOCATION");

                entity.ToTable("LOCATION3815");

                entity.Property(e => e.Locationid)
                    .HasColumnName("LOCATIONID")
                    .HasMaxLength(8);

                entity.Property(e => e.Address)
                    .IsRequired()
                    .HasColumnName("ADDRESS")
                    .HasMaxLength(200);

                entity.Property(e => e.Locname)
                    .IsRequired()
                    .HasColumnName("LOCNAME")
                    .HasMaxLength(50);

                entity.Property(e => e.Manager)
                    .HasColumnName("MANAGER")
                    .HasMaxLength(100);
            });

            modelBuilder.Entity<Order3815>(entity =>
            {
                entity.HasKey(e => e.Orderid)
                    .HasName("PK_ORDER");

                entity.ToTable("ORDER3815");

                entity.Property(e => e.Orderid).HasColumnName("ORDERID");

                entity.Property(e => e.Datetimecreated)
                    .HasColumnName("DATETIMECREATED")
                    .HasColumnType("datetime");

                entity.Property(e => e.Datetimedispatched)
                    .HasColumnName("DATETIMEDISPATCHED")
                    .HasColumnType("datetime");

                entity.Property(e => e.Shippingaddress)
                    .IsRequired()
                    .HasColumnName("SHIPPINGADDRESS")
                    .HasMaxLength(200);

                entity.Property(e => e.Total)
                    .HasColumnName("TOTAL")
                    .HasColumnType("money");

                entity.Property(e => e.Userid).HasColumnName("USERID");

                entity.HasOne(d => d.User)
                    .WithMany(p => p.Order3815)
                    .HasForeignKey(d => d.Userid)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_ORDER_AUTHORISEDPERSON");
            });

            modelBuilder.Entity<OrderByID3815>(entity =>
            {
                entity.HasKey(e => e.Orderid)
                    .HasName("PK_ORDER");

                entity.Property(e => e.Orderid).HasColumnName("ORDERID");

                entity.Property(e => e.Datetimecreated)
                    .HasColumnName("DATETIMECREATED")
                    .HasColumnType("datetime");

                entity.Property(e => e.Datetimedispatched)
                    .HasColumnName("DATETIMEDISPATCHED")
                    .HasColumnType("datetime");

                entity.Property(e => e.Shippingaddress)
                    .IsRequired()
                    .HasColumnName("SHIPPINGADDRESS")
                    .HasMaxLength(200);

                entity.Property(e => e.Total)
                    .HasColumnName("TOTAL")
                    .HasColumnType("money");

                entity.HasKey(e => new { e.Orderid, e.Productid })
                    .HasName("PK_ORDERLINE");

                entity.Property(e => e.Userid).HasColumnName("USERID");

                entity.Property(e => e.Productid).HasColumnName("PRODUCTID");

                entity.Property(e => e.Discount)
                    .HasColumnName("DISCOUNT")
                    .HasColumnType("decimal(18, 0)")
                    .HasDefaultValueSql("((0))");

                entity.Property(e => e.Quantity).HasColumnName("QUANTITY");

                entity.Property(e => e.Subtotal)
                    .HasColumnName("SUBTOTAL")
                    .HasColumnType("money");

            });

            modelBuilder.Entity<Orderline3815>(entity =>
            {
                entity.HasKey(e => new { e.Orderid, e.Productid })
                    .HasName("PK_ORDERLINE");

                entity.ToTable("ORDERLINE3815");

                entity.Property(e => e.Orderid).HasColumnName("ORDERID");

                entity.Property(e => e.Productid).HasColumnName("PRODUCTID");

                entity.Property(e => e.Discount)
                    .HasColumnName("DISCOUNT")
                    .HasColumnType("decimal(18, 0)")
                    .HasDefaultValueSql("((0))");

                entity.Property(e => e.Quantity).HasColumnName("QUANTITY");

                entity.Property(e => e.Subtotal)
                    .HasColumnName("SUBTOTAL")
                    .HasColumnType("money");

                entity.HasOne(d => d.Order)
                    .WithMany(p => p.Orderline3815)
                    .HasForeignKey(d => d.Orderid)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_ORDERLINE_ORDER");

                entity.HasOne(d => d.Product)
                    .WithMany(p => p.Orderline3815)
                    .HasForeignKey(d => d.Productid)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_ORDERLINE_PRODUCT");
            });

            modelBuilder.Entity<Product3815>(entity =>
            {
                entity.HasKey(e => e.Productid)
                    .HasName("PK_PRODUCT");

                entity.ToTable("PRODUCT3815");

                entity.Property(e => e.Productid).HasColumnName("PRODUCTID");

                entity.Property(e => e.Buyprice)
                    .HasColumnName("BUYPRICE")
                    .HasColumnType("money");

                entity.Property(e => e.Prodname)
                    .IsRequired()
                    .HasColumnName("PRODNAME")
                    .HasMaxLength(100);

                entity.Property(e => e.Sellprice)
                    .HasColumnName("SELLPRICE")
                    .HasColumnType("money");
            });

            modelBuilder.Entity<Purchaseorder3815>(entity =>
            {
                entity.HasKey(e => new { e.Productid, e.Locationid, e.Datetimecreated })
                    .HasName("PK_PURCHASEORDER");

                entity.ToTable("PURCHASEORDER3815");

                entity.Property(e => e.Productid).HasColumnName("PRODUCTID");

                entity.Property(e => e.Locationid)
                    .HasColumnName("LOCATIONID")
                    .HasMaxLength(8);

                entity.Property(e => e.Datetimecreated)
                    .HasColumnName("DATETIMECREATED")
                    .HasColumnType("datetime");

                entity.Property(e => e.Quantity).HasColumnName("QUANTITY");

                entity.Property(e => e.Total)
                    .HasColumnName("TOTAL")
                    .HasColumnType("money");

                entity.HasOne(d => d.Location)
                    .WithMany(p => p.Purchaseorder3815)
                    .HasForeignKey(d => d.Locationid)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_PURCHASEORDER_LOCATION");

                entity.HasOne(d => d.Product)
                    .WithMany(p => p.Purchaseorder3815)
                    .HasForeignKey(d => d.Productid)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_PURCHASEORDER_PRODUCT");
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
