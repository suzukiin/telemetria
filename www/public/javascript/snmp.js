async function loadStatus() {
    try {
        const res = await fetch('/cgi-bin/api/get_status.lua');
        const data = await res.json();

        document.getElementById('status_ip_vpn').innerText = data.vpn.ip || 'N/A';
        document.getElementById('status_vpn');
        document.getElementById('status_lte_level').innerText = `${data.lte.rssi} dBm` || 'N/A';
        document.getElementById('status_lte_status');
        document.getElementById('status_info_local').innerText = data.status_info.localidade || 'N/A';
        document.getElementById('status_info_client').innerText = data.status_info.cliente || 'N/A';
        document.getElementById('status_info_id').innerText = data.status_info.id || 'N/A';

        if (data.vpn.status === "up") {
            status_vpn.className = 'badge text-bg-success';
            status_vpn.innerText = 'Conectado';
        } else {
            status_vpn.className = 'badge text-bg-danger';
            status_vpn.innerText = 'Desconectado';
        }

        if (data.lte.rssi >= -85) {
            status_lte_status.className = 'badge text-bg-success';
            status_lte_status.innerText = 'Bom';
        } else if (data.lte.rssi >= -100) {
            status_lte_status.className = 'badge text-bg-warning';
            status_lte_status.innerText = 'Médio';
        } else {
            status_lte_status.className = 'badge text-bg-danger';
            status_lte_status.innerText = 'Fraco';
        }

    } catch (err) {
        console.error('Erro ao carregar status:', err);
    }
}

async function getDevices() {
    try {
        const res = await fetch('/cgi-bin/api/list_devices.lua');
        const devices = await res.json();

        const devicesList = document.getElementById('deviceInfo');
        devicesList.innerHTML = '';

        devices.devices.forEach(element => {
            const deviceCard = document.createElement('div');
            deviceCard.className = 'card mb-3';
            function renderEnum(enumObj) {
                if (!enumObj) return '';

                const items = Object.entries(enumObj)
                    .map(([key, value]) => `<li>${key} → ${value}</li>`)
                    .join('');

                return `
        <div class="mt-2">
            <small class="text-muted">Enumeração:</small>
            <ul class="mb-0">
                ${items}
            </ul>
        </div>
    `;
            }

            function renderOptional(label, value) {
                if (value === null || value === undefined) return '';
                return `<div><small class="text-muted">${label}:</small> ${value}</div>`;
            }

            deviceCard.innerHTML = `
<div class="card-body">

    <!-- Cabeçalho do Device -->
    <div class="d-flex justify-content-between align-items-start">
        <div>
            <h4 class="mb-1">${element.fabricante}</h4>
            <h6 class="mb-1 text-muted">${element.modelo}</h6>
            <small class="text-muted">IP: ${element.ip}</small>
        </div>

        <div class="text-end">
            <button class="btn btn-sm btn-outline-primary mb-1">📝 Editar</button><br>
            <button class="btn btn-sm btn-outline-danger">🗑 Excluir</button>
        </div>
    </div>

    <hr>

    <!-- OIDs -->
    <strong>OIDs monitoradas</strong>

    <div class="mt-3">
        ${element.OIDS.map((oid, index) => {
                const collapseId = `oid_${element.id}_${index}`;

                return `
            <div class="border rounded mb-2">

                <!-- Linha principal -->
                <div
                    class="p-2 d-flex justify-content-between align-items-center"
                    role="button"
                    data-bs-toggle="collapse"
                    data-bs-target="#${collapseId}"
                    aria-expanded="false"
                >
                    <div>
                        <strong>${oid.name}</strong>
                    </div>

                    <span class="badge text-bg-secondary">${oid.type}</span>
                </div>

                <!-- Detalhes -->
                <div class="collapse" id="${collapseId}">
                    <div class="p-3 border-top">

                        <div class="mb-1">
                            <small class="text-muted">OID:</small><br>
                            <code>${oid.oid}</code>
                        </div>

                        <div class="mb-2">
                            <small class="text-muted">Descrição:</small><br>
                            ${oid.description}
                        </div>

                        ${oid.unit ? `
                        <div class="mb-1">
                            <small class="text-muted">Unidade:</small>
                            ${oid.unit}
                        </div>` : ''}

                        ${oid.mask !== null && oid.mask !== undefined ? `
                        <div class="mb-1">
                            <small class="text-muted">Máscara:</small>
                            ${oid.mask}
                        </div>` : ''}

                        ${oid.topic ? `
                        <div class="mb-1">
                            <small class="text-muted">Tópico MQTT:</small><br>
                            <code>${oid.topic}</code>
                        </div>` : ''}

                        ${oid.type === 'boolean' && oid.enum ? `
                        <div class="mt-3">
                            <small class="text-muted">Enumeração:</small>
                            <ul class="list-group mt-1">
                                ${Object.entries(oid.enum).map(([k, v]) => `
                                    <li class="list-group-item py-1 d-flex justify-content-between">
                                        <strong>${k}</strong>
                                        <span>${v}</span>
                                    </li>
                                `).join('')}
                            </ul>
                        </div>` : ''}

                    </div>
                </div>

            </div>
            `;
            }).join('')}
    </div>

</div>
`;


            devicesList.appendChild(deviceCard);
        });
    } catch (err) {
        console.error('Erro ao carregar dispositivos:', err);
    }
}

getDevices();
loadStatus();
setInterval(loadStatus, 60000);