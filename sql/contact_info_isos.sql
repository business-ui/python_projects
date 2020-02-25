use funding_solution_production;
select phone_type ,phone_number ,name, email from phones 
join isos on isos.id = phones.phoneable_id

where isos.name in (
"VS Global Funding",
"True Source Funding",
"Lendrzhub",
"Credit Funding LLC",
"Greystone Capital",
"Empress Funding",
"Looking Glass Funding (Prime Capital)",
"Steady Funds Now",
"Jem Funding Group",
"Reil Lending, LLC",
"Delta Funding Group",
"Edge Capital Funding",
"Fortified Funding",
"Capital Solutions 4 U",
"Premiere Capital Funding",
"Fund-amental Capital",
"Velocity Global Capital",
"Next Up Capital",
"Kalamata Funding",
"12B Capital",
"J.T.T. Funding, INC",
"Phoenix Funding and Finance",
"World Trade Funding LLC",
"H.W. Group LLC",
"HB Capital LLC",
"Bankers Commercial Finance",
"Delta Funding Group 2",
"WeLendYou"
);