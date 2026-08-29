-- ══════════════════════════════════════════
-- Pre-entrega: Consultas SQL de negocio (M4)
-- Autor: Paula Florencia Cordero Lapalma
-- ══════════════════════════════════════════

-- Consulta 1 — Resumen ejecutivo mensual
SELECT 
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(id_venta) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;

-- Consulta 2 — Ranking de productos (Usamos TOP 5 en vez de LIMIT)
SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_generado
FROM ventas
GROUP BY id_producto
ORDER BY total_generado DESC;

-- Consulta 3 — Clientes recurrentes
SELECT 
    id_cliente,
    COUNT(id_venta) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1;

-- Consulta 4 — Meses por encima/por debajo del promedio
SELECT 
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    CASE 
        WHEN SUM(cantidad * precio_unitario) > (
            SELECT SUM(cantidad * precio_unitario) / COUNT(DISTINCT MONTH(fecha_venta)) 
            FROM ventas
        ) THEN 'Por encima'
        ELSE 'Por debajo'
    END AS desempeño_vs_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;

-- ══════════════════════════════════════════
-- HALLAZGOS Y CONCLUSIONES DEL ANÁLISIS
-- 1. El producto con id_producto 1 (Laptop) concentra el mayor volumen de facturación.
-- 2. Hay un comportamiento muy positivo de clientes recurrentes en un corto período de tiempo.
-- 3. La base de datos actual se concentra en el mes de marzo, se requiere cargar histórico para mayor precisión.
-- ══════════════════════════════════════════ 
